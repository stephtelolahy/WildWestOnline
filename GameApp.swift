//
//  GameApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import App
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
            .lift(stateMap: { $0.game })
        ]
    )
}
