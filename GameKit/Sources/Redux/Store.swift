import Combine
import Foundation
import SwiftUI

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

        var hasEffect = false
        for middleware in middlewares {
            if let effect = middleware(newState, action) {
                effect
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: dispatch)
                    .store(in: &subscriptions)
                hasEffect = true
            }
        }

        if !hasEffect {
            completed?()
        }
    }

    public func addMiddleware(_ middleware: @escaping Middleware<State>) {
        middlewares.append(middleware)
    }
}
