//
//  AppStore.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 22/02/2024.
//
import GameCore
import Redux
import Settings

public func createAppStore() -> Store<AppState> {
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
