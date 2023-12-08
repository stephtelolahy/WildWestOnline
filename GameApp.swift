//
//  GameApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import AppUI
import Game
import Redux

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            AppView {
                store
            }
            .environment(\.colorScheme, .light)
        }
    }
}

private var store: Store<AppState> {
    Store<AppState>(
        initial: .init(),
        reducer: AppState.reducer,
        middlewares: [
            LoggerMiddleware(),
            ComposedMiddleware([
                CardEffectsMiddleware(),
                GameLoopMiddleware(),
                ActivateCardsMiddleware(),
                AIAgentMiddleware()
            ])
            .lift(stateMap: { GameState.from(globalState: $0) })
        ]
    )
}

private extension GameState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case let .game(gamePlayState) = lastScreen else {
            return nil
        }

        return gamePlayState.gameState
    }
}
