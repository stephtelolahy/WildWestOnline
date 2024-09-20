//
//  LoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 27/11/2023.
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
