import Combine
import Foundation
import SwiftUI
// swiftlint:disable private_subject

/// ``Reducer`` is a pure function that takes an action and the current state to calculate the new state.
public typealias Reducer<State, Action> = (State, Action) throws -> State
public typealias SelectorReducer<InputState, OutputState, Action> = (InputState, Action) throws -> OutputState

/// ``Middleware`` is a plugin, or a composition of several plugins,
/// that are assigned to the app global  state pipeline in order to
/// handle each action received action, to execute side-effects in response, and eventually dispatch more actions
public typealias Middleware<State, Action> = (State, Action) async -> Action?

/// Namespace for Middlewares
public enum Middlewares {}

/// ``Store`` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class Store<State, Action>: ObservableObject {
    @Published public internal(set) var state: State
    public internal(set) var event: PassthroughSubject<Any, Never>
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
            state = newState
            event.send(action)

            for middleware in middlewares {
                Future<Action?, Never> { promise in
                    Task {
                        let output = await middleware(newState, action)
                        promise(.success(output))
                    }
                }
                .compactMap { $0 }
                .subscribe(on: middlewareSerialQueue)
                .receive(on: RunLoop.main)
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions)
            }
        } catch {
            self.error.send(error)
        }
    }
}
