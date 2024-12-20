//
//  ChainMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//
import Combine

/// The `ChainMiddleware` is a container of inner middlewares
/// that are chained together in the order as they were composed.
/// Whenever an action arrives to be handled by this `ComposedMiddleware`, 
/// it will delegate to its internal chain of middlewares.
/// Only the first non-nil middleware response will be returned
///
public extension Middlewares {
    static func chain<State>(_ middlewares: [Middleware<State>]) -> Middleware<State> {
        { state, action in
            Publishers
                .MergeMany(middlewares.map { $0(state, action) })
                .first()
                .eraseToAnyPublisher()
        }
    }
}
