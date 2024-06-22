//
//  LoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 27/11/2023.
//

public struct LoggerMiddleware<State>: Middleware {
    public init() {}

    public func effect(on action: Action, state: State) async -> Action? {
        print(String(describing: action))
        return nil
    }
}
