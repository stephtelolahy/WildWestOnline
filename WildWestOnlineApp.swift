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

@MainActor private func createStore() -> Store<AppState, AppDependencies> {
    let settingsService = SettingsRepository()

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

    let dependencies = AppDependencies(
        settings: .init(
            savePlayersCount: settingsService.savePlayersCount,
            saveActionDelayMilliSeconds: settingsService.saveActionDelayMilliSeconds,
            saveSimulationEnabled: settingsService.saveSimulationEnabled,
            savePreferredFigure: settingsService.savePreferredFigure
        )
    )

    let initialState = AppState(
        navigation: .init(),
        settings: settings,
        inventory: inventory
    )

    return Store(
        initialState: initialState,
        reducer: appReducer,
        dependencies: dependencies
    )
}
