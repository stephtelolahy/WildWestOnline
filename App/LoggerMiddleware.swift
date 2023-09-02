//
//  LoggerMiddleware.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 03/04/2023.
//

import Combine
import Redux
import Screen

public let loggerMiddleware: Middleware<AppState, AppAction> = { state, action in
    print("➡️ \(action)\n✅ \(state)\n")

    return Empty().eraseToAnyPublisher()
}
