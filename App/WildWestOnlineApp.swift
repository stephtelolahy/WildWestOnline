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

private func createStore() -> Store<AppState, Any> {
    let settingsService = SettingsRepository()
    let cardsService = CardsRepository()

    let settings = SettingsState.makeBuilder()
        .withPlayersCount(settingsService.playersCount())
        .withWaitDelayMilliseconds(settingsService.waitDelayMilliseconds())
        .withSimulation(settingsService.isSimulationEnabled())
        .withPreferredFigure(settingsService.preferredFigure())
        .build()

    let initialState = AppState(
        screens: [.splash],
        settings: settings,
        inventory: cardsService.inventory
    )

    return Store<AppState, Any>(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
            Middlewares.lift(
                Middlewares.updateGame(),
                deriveState: { $0.game },
                deriveAction: { $0 as? GameAction },
                embedAction: { action, _ in action }
            ),
            Middlewares.lift(
                Middlewares.saveSettings(with: settingsService),
                deriveState: { $0.settings },
                deriveAction: { $0 as? SettingsAction },
                embedAction: { action, _ in action }
            ),
            Middlewares.logger()
        ]
    )
}
