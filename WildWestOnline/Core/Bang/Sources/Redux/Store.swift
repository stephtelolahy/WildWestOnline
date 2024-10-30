//
//  Store.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Combine
import Foundation

/// ``Action`` is a plain object that describes what happened.
/// To change something in the state, you need to dispatch an action.
/// Common protocol to which all actions conform.
public protocol Action {}

/// ``Reducer`` is a pure function that takes an action and the current state to calculate the new state.
public typealias Reducer<State> = (State, Action) throws -> State

/// ``Middleware`` is a plugin, or a composition of several plugins,
/// that are assigned to the app global  state pipeline in order to
/// handle each action received action, to execute side-effects in response, and eventually dispatch more actions
public typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>

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
    private let queue = DispatchQueue(label: "redux.store-\(UUID())")

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

            middlewares.forEach { middleware in
                middleware(newState, action)
                    .subscribe(on: queue)
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: dispatch)
                    .store(in: &subscriptions)
            }
        } catch {
            self.error.send(error)
        }
    }
}
