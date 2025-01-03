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
    private let store = createStore()

    var body: some Scene {
        WindowGroup {
            MainCoordinator()
                .environmentObject(store)
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

private func createStore() -> Store<AppState> {
    let settingsService: SettingsService = SettingsRepository()

    let settings = SettingsState.makeBuilder()
        .withPlayersCount(settingsService.playersCount())
        .withActionDelayMilliSeconds(settingsService.actionDelayMilliSeconds())
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
                Middlewares.playAIMove,
                deriveState: { $0.game }
            ),
            Middlewares.lift(
                Middlewares.saveSettings(service: settingsService),
                deriveState: { $0.settings }
            ),
            Middlewares.lift(
                Middlewares.setupGame,
                deriveState: { $0 }
            ),
            Middlewares.logger()
        ]
    )
}
