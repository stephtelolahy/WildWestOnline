import Combine
import Foundation
import SwiftUI
// swiftlint:disable trailing_closure

/// `Store` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class Store<State: Equatable>: ObservableObject {
    @Published public internal(set) var state: State

    private let reducer: Reducer<State>
    private let middlewares: [any Middleware<State>]
    private var subscriptions: [UUID: AnyCancellable] = [:]
    private let middlewareSerialQueue = DispatchQueue(label: "store.middleware-\(UUID())")

    public init(
        initial state: State,
        reducer: @escaping Reducer<State> = { state, _ in state },
        middlewares: [any Middleware<State>] = []
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }

    public func dispatch(_ action: Action) {
        let newState = reducer(state, action)

        middlewares.forEach { middleware in
            let key = UUID()
            middleware.performAsFuture(on: action, state: newState)
                .compactMap { $0 }
                .subscribe(on: middlewareSerialQueue)
                .receive(on: RunLoop.main)
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.subscriptions.removeValue(forKey: key)
                })
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions, key: key)
        }

        state = newState
    }
}

private extension Middleware {
    func performAsFuture(on action: Action, state: State) -> Future<Action?, Never> {
        Future { promise in
            Task {
                let output = await self.effect(on: action, state: state)
                promise(.success(output))
            }
        }
    }
}

private extension AnyCancellable {
    func store(in dictionary: inout [UUID: AnyCancellable], key: UUID) {
        dictionary[key] = self
    }
}
