//
//  ComposedMiddleware.swift
//
//
//  Created by Hugues Telolahy on 08/06/2024.
//

/// The ``ComposedMiddleware`` is a container of inner middlewares
/// that are chained together in the order as they were composed.
/// Whenever an action arrives to be handled by this `ComposedMiddleware`,
/// it will delegate to its internal chain of middlewares.
/// Only the first non-nil middleware response will be returned
public struct ComposedMiddleware<State, Action>: Middleware {
    private let middlewares: [any Middleware]

    public init(_ middlewares: [any Middleware]) {
        self.middlewares = middlewares
    }

    public func handle(_ action: Action, state: State) async -> Action? {
        for middleware in middlewares {
            guard let typedMiddleware = middleware as? any Middleware<State, Action> else {
                fatalError("invalid middleware type")
            }

            if let response = await typedMiddleware.handle(action, state: state) {
                return response
            }
        }

        return nil
    }
}
