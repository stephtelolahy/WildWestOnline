//
//  LoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 27/11/2023.
//
import Combine

public final class LoggerMiddleware<State>: Middleware<State> {
    override public func handle(action: Action, state: State) -> AnyPublisher<Action, Never>? {
        print("➡️ \(action)\n✅ \(state)\n")
        return nil
    }
}
