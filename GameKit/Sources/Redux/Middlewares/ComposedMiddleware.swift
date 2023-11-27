//
//  ComposedMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//
import Combine

/// The `ComposedMiddleware` is a container of inner middlewares 
/// that are chained together in the order as they were composed.
/// Whenever an action arrives to be handled by this `ComposedMiddleware`, 
/// it will delegate to its internal chain of middlewares.
/// Only the first non-nil middleware response will be returned
public final class ComposedMiddleware<State>: Middleware<State> {
    private let middlewares: [Middleware<State>]

    public init(middlewares: [Middleware<State>]) {
        self.middlewares = middlewares
    }

    override func handle(action: Action, state: State) -> AnyPublisher<Action, Never>? {
        for middleware in middlewares {
            if let response = middleware.handle(action: action, state: state) {
                return response
            }
        }

        return nil
    }
}
