import Foundation
import Combine
import SwiftUI

public protocol Action {}

public typealias Reducer<State> = (State, Action) -> State
public typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>

public final class Store<State>: ObservableObject {

    @Published public private(set) var state: State
    public private (set) var log: [Action] = []

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

        middlewares.forEach { middleware in
            middleware(newState, action)
                .receive(on: RunLoop.main)
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions)
        }
    }

    public func addMiddleware(_ middleware: @escaping Middleware<State>) {
        middlewares.append(middleware)
    }
}
