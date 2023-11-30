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
        ComposedMiddleware([
            CardEffectsMiddleware(),
            NextActionMiddleware(),
            ActivateCardsMiddleware()
        ])
        .lift(stateMap: appStateToGameState),
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

private var appStateToGameState: (AppState) -> GameState? = { state in
    guard let lastScreen = state.screens.last,
          case let .game(gamePlayState) = lastScreen else {
        return nil
    }

    return gamePlayState.gameState
}
