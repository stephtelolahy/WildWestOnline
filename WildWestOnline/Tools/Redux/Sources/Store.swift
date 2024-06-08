//
//  Store.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2024.
//

import Combine
import Foundation
import SwiftUI

/// ``Store`` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public final class Store<State, Action>: ObservableObject {
    @Published public internal(set) var state: State

    private let reducer: Reducer<State, Action>
    private let middlewares: [Middleware<State, Action>]
    private var subscriptions = Set<AnyCancellable>()
    private let middlewareSerialQueue = DispatchQueue(label: "store.middleware-\(UUID())")

    public init(
        initial state: State,
        reducer: @escaping Reducer<State, Action> = { state, _ in state },
        middlewares: [Middleware<State, Action>] = []
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }

    public func dispatch(_ action: Action) {
        let newState = reducer(state, action)
        state = newState
        for middleware in middlewares {
            middleware.handleAsFuture(action, state: newState)
                .subscribe(on: middlewareSerialQueue)
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions)
        }
    }
}

private extension Middleware {
    func handleAsFuture(_ action: Action, state: State) -> Future<Action?, Never> {
        Future { promise in
            Task { [weak self] in
                let output = await self?.handle(action, state: state)
                promise(.success(output))
            }
        }
    }
}
