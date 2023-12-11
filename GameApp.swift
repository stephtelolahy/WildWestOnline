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
import SettingsUI

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            AppView {
                createStore()
            }
            .environment(\.colorScheme, .light)
            .accentColor(AppColor.button)
        }
    }
}

private func createStore() -> Store<AppState> {
    Store<AppState>(
        initial: .init(
            screens: [.splash],
            settings: cachedSettings()
        ),
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

private func cachedSettings() -> SettingsState {
    let defaultPlayersCount = 5
    let defaultSimulation = false
    return .init(
        playersCount: defaultPlayersCount,
        simulation: defaultSimulation
    )
}
