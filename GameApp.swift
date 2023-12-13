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
import SettingsUI
import Utils

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
    
    let settingsService = SettingsService()
    
    let cachedSettings = SettingsState(
        playersCount: settingsService.playersCount,
        simulation: settingsService.simulationEnabled
    )
    
    let initialState = AppState(
        screens: [.splash],
        settings: cachedSettings
    )
    
    return Store<AppState>(
        initial: initialState,
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
            SettingsMiddleware(cacheService: settingsService)
                .lift { SettingsState.from(globalState: $0) }
        ]
    )
}
