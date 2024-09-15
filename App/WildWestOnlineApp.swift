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
            RootView(store: createAppStore())
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

private func createAppStore() -> Store<AppState> {
    let settingsService = SettingsRepository()
    let cardsService = CardsRepository()

    let settings = SettingsState.makeBuilder()
        .withPlayersCount(settingsService.playersCount())
        .withWaitDelayMilliseconds(settingsService.waitDelayMilliseconds())
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
                deriveState: { $0.game },
                deriveAction: { $0 as? GameAction },
                embedAction: { $0 }
            ),
            Middlewares.lift(
                Middlewares.saveSettings(with: settingsService),
                deriveState: { $0.settings },
                deriveAction: { $0 as? SettingsAction },
                embedAction: { $0 }
            ),
            Middlewares.logger()
        ]
    )
}
