//
//  GameApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Redux
import Screen
import Game

private let store = Store<AppState>(
    initial: AppState(),
    reducer: AppState.reducer,
    middlewares: [
        loggerMiddleware,
//        gameLoopMiddleware,
//        eventLoggerMiddleware
    ]
)

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(store)
        }
    }
}
