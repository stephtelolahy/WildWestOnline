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
            print(String(describing: action))
            return nil
        }
    }
}
