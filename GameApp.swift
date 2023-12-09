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
import Theme

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            AppView {
                store
            }
            .environment(\.colorScheme, .light)
            .accentColor(AppColor.button)
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
