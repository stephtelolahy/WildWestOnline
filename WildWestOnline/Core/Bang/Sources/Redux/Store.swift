//
//  Store.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 02/11/2024.
//

import Combine
import Foundation
import SwiftUI
// swiftlint:disable private_subject

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
public typealias Middleware<State> = (State, Action) -> Action?

/// Namespace for Middlewares
public enum Middlewares {}

/// ``Store`` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class Store<State>: ObservableObject {
    @Published public internal(set) var state: State
    public internal(set) var eventPublisher: PassthroughSubject<Action, Never>
    public internal(set) var errorPublisher: PassthroughSubject<Error, Never>

    private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]
    private var cancellables: Set<AnyCancellable> = []
    private let queue = DispatchQueue(label: "store-\(UUID())")
    private var completion: (() -> Void)?

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
            runSideEfects(action, newState: newState)
        } catch {
            errorPublisher.send(error)
            completion?()
        }
    }

    private var queuedEffects = 0
    private var receivedEffects: [Action?] = []

    private func runSideEfects(_ action: Action, newState: State) {
        queuedEffects = middlewares.count
        receivedEffects = []

        for middleware in middlewares {
            Deferred {
                Future<Action?, Never> { promise in
                    let output = middleware(newState, action)
                    promise(.success(output))
                }
            }
            .eraseToAnyPublisher()
                .subscribe(on: queue)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newAction in
                    guard let self else {
                        return
                    }

                    queuedEffects -= 1
                    receivedEffects.append(newAction)

                    if queuedEffects == 0 && receivedEffects.allSatisfy({ $0 == nil }) {
                        completion?()
                        return
                    }

                    if let newAction {
                        dispatch(newAction)
                    }
                }
                .store(in: &cancellables)
        }
    }
}
