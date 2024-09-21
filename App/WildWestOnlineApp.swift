//
//  WildWestOnlineApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import AppCore
import CardsData
import GameCore
import Redux
import SettingsCore
import SettingsData
import NavigationCore
import SwiftUI
import Theme

@main
struct WildWestOnlineApp: App {
    @Environment(\.theme) private var theme

    var body: some Scene {
        WindowGroup {
            MainCoordinator()
                .environmentObject(appStore())
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

private func appStore() -> Store<AppState> {
    let settingsService = SettingsRepository()
    let cardsService = CardsRepository()

    let settings = SettingsState.makeBuilder()
        .withPlayersCount(settingsService.playersCount())
        .withWaitDelaySeconds(settingsService.waitDelaySeconds())
        .withSimulation(settingsService.isSimulationEnabled())
        .withPreferredFigure(settingsService.preferredFigure())
        .build()

    let initialState = AppState(
        navigation: .init(),
        settings: settings,
        inventory: cardsService.inventory
    )

    return Store<AppState>(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
            Middlewares.lift(
                Middlewares.updateGame(),
                deriveState: { $0.game }
            ),
            Middlewares.lift(
                Middlewares.saveSettings(service: settingsService),
                deriveState: { $0.settings }
            ),
            Middlewares.lift(
                Middlewares.gameSetup(),
                deriveState: { $0 }
            ),
            Middlewares.logger()
        ]
    )
}
