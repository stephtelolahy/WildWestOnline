//
//  LoggerMiddleware.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 02/11/2024.
//

import Combine

public extension Middlewares {
    static func logger<State>() -> Middleware<State> {
        { _, action in
            Deferred {
                Future<Action?, Never> { promise in
                    print("✅" + String(describing: action))
                    promise(.success(nil))
                }
            }
            .eraseToAnyPublisher()
        }
    }
}
