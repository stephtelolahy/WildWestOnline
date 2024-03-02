import Combine
import Foundation
import SwiftUI

/// `Store` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class Store<State: Equatable>: ObservableObject {
    @Published public internal(set) var state: State
    public private(set) var log: [Action] = []

    private let reducer: Reducer<State>
    private var middlewares: [Middleware<State>]
    private var subscriptions = Set<AnyCancellable>()

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
        state = reducer(state, action)
        log.append(action)
        DispatchQueue.global().async { [weak self] in
            self?.handlEffect(on: action)
        }
    }

    private func handlEffect(on action: Action) {
        let currentState = state
        for middleware in middlewares {
            Future { await middleware.effect(on: action, state: currentState) }
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] action in
                    if let action {
                        self?.dispatch(action)
                    }
                })
                .store(in: &subscriptions)
        }
    }

    public func addMiddleware(_ middleware: Middleware<State>) {
        middlewares.append(middleware)
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
