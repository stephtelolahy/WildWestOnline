import Combine
import Foundation
import SwiftUI

/// `Store` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class StoreV1<State: Equatable>: ObservableObject {
    @Published public internal(set) var state: State

    private let reducer: ReducerV1<State>
    private let middlewares: [MiddlewareV1<State>]
    private var subscriptions = Set<AnyCancellable>()
    private let middlewareSerialQueue = DispatchQueue(label: "store.middleware-\(UUID())")

    public init(
        initial state: State,
        reducer: @escaping ReducerV1<State> = { state, _ in state },
        middlewares: [MiddlewareV1<State>] = []
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }

    public func dispatch(_ action: ActionV1) {
        let newState = reducer(state, action)
        state = newState
        for middleware in middlewares {
            middleware.performAsFuture(on: action, state: newState)
                .subscribe(on: middlewareSerialQueue)
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions)
        }
    }
}

private extension MiddlewareV1 {
    func performAsFuture(on action: ActionV1, state: State) -> Future<ActionV1?, Never> {
        Future { promise in
            Task {
                let output = await self.effect(on: action, state: state)
                promise(.success(output))
            }
        }
    }
}
