import Combine
import Foundation
import SwiftUI

/// `Store` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public final class Store<State>: ObservableObject {
    @Published public private(set) var state: State
    public private (set) var log: [Action] = []
    public var completed: (() -> Void)?

    private let queue = DispatchQueue(label: "store.queue", qos: .userInitiated)
    private let reducer: Reducer<State>
    private var middlewares: [Middleware<State>]
    private var subscriptions = Set<AnyCancellable>()

    public init(
        initial state: State,
        reducer: @escaping Reducer<State>,
        middlewares: [Middleware<State>]
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }

    public func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }

    private func dispatch(_ currentState: State, _ action: Action) {
        log.append(action)

        let newState = reducer(currentState, action)
        state = newState

        var middlewaresHaveEffect = false
        for middleware in middlewares {
            if let effect = middleware.handle(action: action, state: newState) {
                effect
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: dispatch)
                    .store(in: &subscriptions)
                middlewaresHaveEffect = true
            }
        }

        if !middlewaresHaveEffect {
            completed?()
        }
    }

    public func addMiddleware(_ middleware: Middleware<State>) {
        middlewares.append(middleware)
    }
}
