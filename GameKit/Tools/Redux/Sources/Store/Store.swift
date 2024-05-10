import Combine
import Foundation
import SwiftUI

/// `Store` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class Store<State: Equatable>: ObservableObject {
    @Published public internal(set) var state: State

    private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]
    private var subscriptions = Set<AnyCancellable>()
    private let middlewareSerialQueue = DispatchQueue(label: "store.middleware")

    public init(
        initial state: State,
        reducer: @escaping Reducer<State> = { state, _ in state },
        middlewares: [Middleware<State>] = []
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }

    public func dispatch(_ action: Action) {
        let newState = reducer(state, action)
        state = newState
        for middleware in middlewares {
            middleware.asPublisher(on: action, state: newState)
                .subscribe(on: middlewareSerialQueue)
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink(receiveValue: self.dispatch)
                .store(in: &subscriptions)
        }
    }
}

private extension Middleware {
    func asPublisher(on action: Action, state: State) -> AnyPublisher<Action?, Never> {
        Future { promise in
            Task {
                let output = await self.effect(on: action, state: state)
                promise(.success(output))
            }
        }
        .eraseToAnyPublisher()
    }
}
