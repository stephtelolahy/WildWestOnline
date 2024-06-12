//
//  WildWestOnlineApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import App
import AppCore
import CardsRepository
import GameCore
import Redux
import SettingsCore
import SettingsRepository
import SwiftUI
import Theme

@main
struct WildWestOnlineApp: App {
    @Environment(\.theme) private var theme

    var body: some Scene {
        WindowGroup {
            AppView {
                createStore()
            }
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

private func createStore() -> Store<AppState, AppAction> {
    let settingsService = SettingsRepository()
    let cardsService = CardsRepository()

    let settings = SettingsState.makeBuilder()
        .withInventory(cardsService.inventory)
        .withPlayersCount(settingsService.playersCount)
        .withWaitDelayMilliseconds(settingsService.waitDelayMilliseconds)
        .withSimulation(settingsService.simulationEnabled)
        .withPreferredFigure(settingsService.preferredFigure)
        .build()

    let initialState = AppState(
        screens: [.splash],
        settings: settings
    )

    return Store(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
//            updateGameMiddleware()
//                .lift { $0.game },
//            SaveSettingsMiddleware(service: settingsService)
//                .lift { $0.settings },
            LoggerMiddleware()
        ]
    )
}
