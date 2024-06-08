//
//  LoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 27/11/2023.
//

public final class LoggerMiddleware<State>: MiddlewareV1<State> {
    override public func effect(on action: ActionV1, state: State) async -> ActionV1? {
        print(String(describing: action))
        return nil
    }
}
