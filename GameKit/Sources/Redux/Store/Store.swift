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
    private let completed: (() -> Void)?
    private var subscriptions = Set<AnyCancellable>()

    public init(
        initial state: State,
        reducer: @escaping Reducer<State> = { state, _ in state },
        middlewares: [Middleware<State>] = [],
        completed: (() -> Void)? = nil
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
        self.completed = completed
    }

    public func dispatch(_ action: Action) {
        DispatchQueue.main.async {
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
