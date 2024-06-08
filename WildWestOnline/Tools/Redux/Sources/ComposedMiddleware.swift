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
public final class ComposedMiddleware<State, Action>: Middleware<State, Action> {
    private let middlewares: [Middleware<State, Action>]

    public init(_ middlewares: [Middleware<State, Action>]) {
        self.middlewares = middlewares
    }

    public override func handle(_ action: Action, state: State) async -> Action? {
        for middleware in middlewares {
            if let response = await middleware.handle(action, state: state) {
                return response
            }
        }

        return nil
    }
}
