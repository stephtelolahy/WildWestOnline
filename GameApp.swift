//
//  GameApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import App
import GameCore
import Redux
import Settings
import Theme

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
        waitDelayMilliseconds: settingsService.waitDelayMilliseconds,
        simulation: settingsService.simulationEnabled
    )

    let initialState = AppState(
        screen: .splash,
        settings: cachedSettings
    )

    return Store<AppState>(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
            gameLoopMiddleware()
                .lift { GameState.from(globalState: $0) },
            SettingsUpdateMiddleware(cacheService: settingsService)
                .lift { SettingsState.from(globalState: $0) },
            LoggerMiddleware()
        ]
    )
}
