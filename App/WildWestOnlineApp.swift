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

private func createStore() -> Store<AppState> {
    let settingsService = SettingsRepository()
    let cardsService = CardsRepository()

    let settings = SettingsState.makeBuilder()
        .withInventory(cardsService.inventory)
        .withPlayersCount(settingsService.playersCount())
        .withWaitDelayMilliseconds(settingsService.waitDelayMilliseconds())
        .withSimulation(settingsService.isSimulationEnabled())
        .withPreferredFigure(settingsService.preferredFigure())
        .build()

    let initialState = AppState(
        screens: [.splash],
        settings: settings
    )

    return Store<AppState>(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
            Middlewares.lift(Middlewares.updateGame(), stateMap: { $0.game }),
            Middlewares.lift(Middlewares.saveSettings(with: settingsService), stateMap: { $0.settings }),
            Middlewares.logger()
        ]
    )
}
