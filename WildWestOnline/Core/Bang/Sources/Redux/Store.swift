//
//  Store.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 02/11/2024.
//

import Combine
import Foundation
// swiftlint:disable private_subject unowned_variable_capture

/// ``Action`` is a plain object that describes what happened.
/// To change something in the state, you need to dispatch an action.
/// Common protocol to which all actions conform.
///
public protocol Action: Sendable {}

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
public class Store<State>: ObservableObject, @unchecked Sendable {
    @Published public internal(set) var state: State
    public internal(set) var eventPublisher: PassthroughSubject<Action, Never>
    public internal(set) var errorPublisher: PassthroughSubject<Error, Never>

    private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]
    private var completion: (() -> Void)?
    private var subscribedEffects: Int = 0
    private var completedEffects: Int = 0

    public init(
        initial state: State,
        reducer: @escaping Reducer<State> = { state, _ in state },
        middlewares: [Middleware<State>] = [],
        completion: (() -> Void)? = nil
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
        self.eventPublisher = .init()
        self.errorPublisher = .init()
        self.completion = completion
    }

    public func dispatch(_ action: Action) {
        do {
            let newState = try reducer(state, action)
            eventPublisher.send(action)
            state = newState
            subscribedEffects += middlewares.count
            Task.detached { [unowned self] in
                for middleware in middlewares {
                    let output = await middleware(newState, action)
                    DispatchQueue.main.async { [unowned self] in
                        if let output {
                            dispatch(output)
                        }

                        completedEffects += 1
                        if completedEffects == subscribedEffects {
                            completion?()
                        }
                    }
                }
            }
        } catch {
            errorPublisher.send(error)
            completion?()
        }
    }
}
