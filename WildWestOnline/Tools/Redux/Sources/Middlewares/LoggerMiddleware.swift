//
//  LoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 27/11/2023.
//

public struct LoggerMiddleware<State, Action>: Middleware {
    public init() {}

    public func handle(_ action: Action, state: State) async -> Action? {
        print(String(describing: action))
        return nil
    }
}
