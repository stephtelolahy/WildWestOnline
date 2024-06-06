//
//  ComposedMiddlewareV1.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

/// The `ComposedMiddleware` is a container of inner middlewares 
/// that are chained together in the order as they were composed.
/// Whenever an action arrives to be handled by this `ComposedMiddleware`, 
/// it will delegate to its internal chain of middlewares.
/// Only the first non-nil middleware response will be returned
public final class ComposedMiddlewareV1<State>: MiddlewareV1<State> {
    private let middlewares: [MiddlewareV1<State>]

    public init(_ middlewares: [MiddlewareV1<State>]) {
        self.middlewares = middlewares
    }

    override public func effect(on action: ActionV1, state: State) async -> ActionV1? {
        for middleware in middlewares {
            if let response = await middleware.effect(on: action, state: state) {
                return response
            }
        }

        return nil
    }
}
