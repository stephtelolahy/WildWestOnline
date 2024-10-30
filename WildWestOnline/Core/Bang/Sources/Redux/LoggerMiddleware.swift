//
//  LoggerMiddleware.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Combine

public extension Middlewares {
    static func logger<State>() -> Middleware<State> {
        { _, action in
            print(String(describing: action))
            return Empty().eraseToAnyPublisher()
        }
    }
}
