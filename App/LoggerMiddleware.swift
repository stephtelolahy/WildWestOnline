//
//  LoggerMiddleware.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 03/04/2023.
//

import Combine
import Redux
import Screen

class LoggerMiddleware: Middleware<AppState> {
    override func handle(action: Action, state: AppState) -> AnyPublisher<Action, Never>? {
        print("➡️ \(action)\n✅ \(state)\n")

        return nil
    }
}
