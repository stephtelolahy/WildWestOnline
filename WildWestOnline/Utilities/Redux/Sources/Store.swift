import Combine
import Foundation
import SwiftUI
// swiftlint:disable private_subject

/// ``Action`` is a plain object that describes what happened.
/// To change something in the state, you need to dispatch an action.
///
public protocol Action {}

/// ``Reducer`` is a pure function that takes an action and the current state to calculate the new state.
public typealias Reducer<State> = (State, Action) throws -> State

/// ``Middleware`` is a plugin, or a composition of several plugins,
/// that are assigned to the app global  state pipeline in order to
/// handle each action received action, to execute side-effects in response, and eventually dispatch more actions
public typealias Middleware<State> = (State, Action) async -> Action?

/// Namespace for Middlewares
public enum Middlewares {}

/// ``Store`` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class Store<State>: ObservableObject {
    @Published public internal(set) var state: State
    public internal(set) var event: PassthroughSubject<Any, Never>
    public internal(set) var error: PassthroughSubject<Error, Never>

    private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]
    private var subscriptions: Set<AnyCancellable> = []
    private let middlewareSerialQueue = DispatchQueue(label: "store.middleware-\(UUID())")

    public init(
        initial state: State,
        reducer: @escaping Reducer<State> = { state, _ in state },
        middlewares: [Middleware<State>] = []
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
            event.send(action)
            state = newState

            for middleware in middlewares {
                Future<Action?, Never>(operation: {
                    await middleware(newState, action)
                })
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

    public func dispatch(_ thunk: Thunk) {
        thunk(
            .init(
                dispatch: { [weak self] action in
                    self?.dispatch(action)
                },
                getState: { [weak self] in
                    self?.state
                }
            )
        )
    }
}

/// The word "thunk" is a programming term that means "a piece of code that does some delayed work".
/// Rather than execute some logic now, we can write a function body or code that can be used to perform the work later.
/// ``Thunks`` are a pattern of writing functions with logic inside that can interact with the store later
///
public typealias Thunk = (ThunkArg) -> Void

public struct ThunkArg {
    public let dispatch: (Action) -> Void
    public let getState: () -> Any?

    public init(
        dispatch: @escaping (Action) -> Void,
        getState: @escaping () -> Any?
    ) {
        self.dispatch = dispatch
        self.getState = getState
    }
}

private extension Future where Failure == Never {
    convenience init(operation: @escaping () async -> Output) {
        self.init { promise in
            Task {
                let output = await operation()
                promise(.success(output))
            }
        }
    }
}
