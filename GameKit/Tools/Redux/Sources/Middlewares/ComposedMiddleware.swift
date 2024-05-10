//
//  ComposedMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

/// The `ComposedMiddleware` is a container of inner middlewares 
/// that are chained together in the order as they were composed.
/// Whenever an action arrives to be handled by this `ComposedMiddleware`, 
/// it will delegate to its internal chain of middlewares.
/// Only the first non-nil middleware response will be returned
public final class ComposedMiddleware<State>: Middleware<State> {
    private let middlewares: [Middleware<State>]

    public init(_ middlewares: [Middleware<State>]) {
        self.middlewares = middlewares
    }

    override public func effect(on action: Action, state: State) async -> Action? {
        for middleware in middlewares {
            if let response = await middleware.effect(on: action, state: state) {
                print("⚙️ \(middleware) > \(response)")
                return response
            }
        }

        print("🛑 No middleware emitted action")
        return nil
    }
}
