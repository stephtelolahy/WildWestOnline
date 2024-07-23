import Combine
import Foundation
import SwiftUI
// swiftlint:disable private_subject

/// ``Store`` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class Store<State, Action>: ObservableObject {
    @Published public internal(set) var state: State
    public internal(set) var event: PassthroughSubject<Action, Never>
    public internal(set) var error: PassthroughSubject<Error, Never>

    private let reducer: Reducer<State, Action>
    private let middlewares: [Middleware<State, Action>]
    private var subscriptions: Set<AnyCancellable> = []
    private let middlewareSerialQueue = DispatchQueue(label: "store.middleware-\(UUID())")

    public init(
        initial state: State,
        reducer: @escaping Reducer<State, Action> = { state, _ in state },
        middlewares: [Middleware<State, Action>] = []
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
        self.event = .init()
        self.error = .init()
    }

    public func dispatch(_ action: Action) {
        do {
            let newState = try reducer(state, action)
            middlewares.forEach { middleware in
                Future<Action, Never>.create(from: middleware, state: newState, action: action)
                    .compactMap { $0 }
                    .subscribe(on: middlewareSerialQueue)
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: dispatch)
                    .store(in: &subscriptions)
            }
            state = newState
            event.send(action)
        } catch {
            self.error.send(error)
        }
    }
}

/// ``Reducer`` is a pure function that takes an action and the current state to calculate the new state.
public typealias Reducer<State, Action> = (State, Action) throws -> State

public typealias SelectorReducer<InputState, OutputState, Action> = (InputState, Action) throws -> OutputState

/// ``Middleware`` is a plugin, or a composition of several plugins,
/// that are assigned to the app global  state pipeline in order to
/// Handle each action received action, to execute side-effects in response, and eventually dispatch more actions
public typealias Middleware<State, Action> = (State, Action) async -> Action?

/// Namespace for Middlewares
public enum Middlewares {}

/// Class for holding value type
public class ClassWrapper<T> {
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
}

private extension Future {
    static func create<State, Action>(
        from middleware: @escaping Middleware<State, Action>,
        state: State,
        action: Action
    ) -> Future<Action?, Never> {
        Future<Action?, Never> { promise in
            Task {
                let output = await middleware(state, action)
                promise(.success(output))
            }
        }
    }
}
