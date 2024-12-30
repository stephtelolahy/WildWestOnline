//
//  WildWestOnlineApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import Redux
import AppCore
import GameCore
import CardsData
import SettingsCore
import SettingsData
import SwiftUI
import Theme
import MainUI

@main
struct WildWestOnlineApp: App {
    @Environment(\.theme) private var theme

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appStore())
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

private func appStore() -> Store<AppState> {
    let settingsService: SettingsService = SettingsRepository()

    let settings = SettingsState.makeBuilder()
        .withPlayersCount(settingsService.playersCount())
        .withWaitDelaySeconds(settingsService.actionDelayMilliSeconds())
        .withSimulation(settingsService.isSimulationEnabled())
        .withPreferredFigure(settingsService.preferredFigure())
        .build()

    let inventory = Inventory(
        cards: Cards.all,
        figures: Figures.bang,
        cardSets: CardSets.bang,
        defaultAbilities: DefaultAbilities.all
    )

    let initialState = AppState(
        navigation: .init(),
        settings: settings,
        inventory: inventory
    )

    return Store<AppState>(
        initial: initialState,
        reducer: AppReducer().reduce,
        middlewares: [
            Middlewares.lift(
                Middlewares.updateGame,
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
