//
//  LoggerMiddleware.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 03/04/2023.
//

import Combine
import Redux
import Screen

let loggerMiddleware: Middleware<AppState> = { state, action in
    print("➡️ \(action)\n✅ \(state)\n")
    
    return Empty<Action, Never>().eraseToAnyPublisher()
}
