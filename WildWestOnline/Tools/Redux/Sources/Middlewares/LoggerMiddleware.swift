//
//  LoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 27/11/2023.
//

public final class LoggerMiddleware<State>: Middleware<State> {
    override public func effect(on action: Action, state: State) async -> Action? {
        print(String(describing: action))
        return nil
    }
}
