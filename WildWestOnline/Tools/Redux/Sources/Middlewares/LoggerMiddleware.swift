// swiftlint:disable:this file_name
//
//  LoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 27/11/2023.
//

public extension Middlewares {
    static func logger<State>() -> Middleware<State> {
        { _, action in
            print(String(describing: action))
            return nil
        }
    }
}
