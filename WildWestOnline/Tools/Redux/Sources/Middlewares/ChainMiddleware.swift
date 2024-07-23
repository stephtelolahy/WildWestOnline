// swiftlint:disable:this file_name
//
//  ChainMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

/// The `ChainMiddleware` is a container of inner middlewares
/// that are chained together in the order as they were composed.
/// Whenever an action arrives to be handled by this `ComposedMiddleware`, 
/// it will delegate to its internal chain of middlewares.
/// Only the first non-nil middleware response will be returned
///
public extension Middlewares {
    static func chain<State, Action>(_ middlewares: [Middleware<State, Action>]) -> Middleware<State, Action> {
        { state, action in
            for middleware in middlewares {
                if let response = await middleware(state, action) {
                    return response
                }
            }

            return nil
        }
    }
}
