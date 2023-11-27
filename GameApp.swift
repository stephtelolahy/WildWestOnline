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
    initial: .init(),
    reducer: AppState.reducer,
    middlewares: [
        LoggerMiddleware(),
        EventLoggerMiddleware()
            .lift(stateMap: extractGameState),
        ComposedMiddleware(middlewares: [
            CardEffectsMiddleware(),
            NextActionMiddleware(),
            ActivateCardsMiddleware()
        ])
        .lift(stateMap: extractGameState),
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

private var extractGameState: (AppState) -> GameState? = { state in
    guard let lastScreen = state.screens.last,
          case let .game(gamePlayState) = lastScreen,
          let gameState = gamePlayState.gameState else {
        return nil
    }
    return gameState
}
