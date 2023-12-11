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
            .lift(stateMap: { GameState.from(globalState: $0) }),
            SettingsCacheMiddleware()
                .lift { SettingsState.from(globalState: $0) }
        ]
    )
}

private func cachedSettings() -> SettingsState {
    let playersCount = (UserDefaults.standard.value(forKey: "settings.playersCount") as? Int) ?? 5
    let simulation = UserDefaults.standard.bool(forKey: "settings.simulation")
    return .init(
        playersCount: playersCount,
        simulation: simulation
    )
}
