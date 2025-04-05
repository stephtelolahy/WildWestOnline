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
            MainCoordinator {
                createStore()
            }
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

@MainActor private func createStore() -> Store<AppFeature.State, AppFeature.Dependencies> {
    let settingsService = SettingsRepository()

    let settings = SettingsFeature.State.makeBuilder()
        .withPlayersCount(settingsService.playersCount())
        .withActionDelayMilliSeconds(settingsService.actionDelayMilliSeconds())
        .withSimulation(settingsService.isSimulationEnabled())
        .withPreferredFigure(settingsService.preferredFigure())
        .build()

    let inventory = Inventory(
        cards: Cards.all,
        figures: Figures.allNames,
        cardSets: CardSets.bang,
        defaultAbilities: DefaultAbilities.all
    )

    let initialState = AppFeature.State(
        navigation: .init(),
        settings: settings,
        inventory: inventory
    )

    let dependencies = AppFeature.Dependencies(
        settings: .init(
            savePlayersCount: settingsService.savePlayersCount,
            saveActionDelayMilliSeconds: settingsService.saveActionDelayMilliSeconds,
            saveSimulationEnabled: settingsService.saveSimulationEnabled,
            savePreferredFigure: settingsService.savePreferredFigure
        )
    )

    return Store(
        initialState: initialState,
        reducer: AppFeature.reduce,
        dependencies: dependencies
    )
}
