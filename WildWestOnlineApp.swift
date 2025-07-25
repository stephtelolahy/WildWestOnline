//
//  WildWestOnlineApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import Redux
import AppCore
import GameCore
import GameData
import SettingsCore
import SettingsData
import SwiftUI
import Theme
import AppUI

@main
struct WildWestOnlineApp: App {
    @Environment(\.theme) private var theme

    var body: some Scene {
        WindowGroup {
            AppCoordinator {
                createStore()
            }
            .accentColor(theme.colorAccent)
        }
    }
}

@MainActor private func createStore() -> Store<AppFeature.State, AppFeature.Dependencies> {
    let settingsService = SettingsRepository()

    let settings = SettingsFeature.State.makeBuilder()
        .withPlayersCount(settingsService.playersCount)
        .withActionDelayMilliSeconds(settingsService.actionDelayMilliSeconds)
        .withSimulation(settingsService.simulationEnabled)
        .withPreferredFigure(settingsService.preferredFigure)
        .build()

    let inventory = Inventory(
        cards: Cards.all,
        deck: Deck.bang
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
