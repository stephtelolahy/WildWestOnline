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
import NavigationCore
import SwiftUI
import Theme
import AppUI
import AudioPlayer

@main
struct WildWestOnlineApp: App {
    @Environment(\.theme) private var theme

    var body: some Scene {
        WindowGroup {
            AppCoordinator {
                createStore()
            }
            .accentColor(theme.colorAccent)
            .task {
                await AudioPlayer.shared.load(AudioPlayer.Sound.allSfx)
            }
        }
    }
}

@MainActor private func createStore() -> Store<AppFeature.State, AppFeature.Action, AppFeature.Dependencies> {
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
        inventory: inventory,
        navigation: .init(),
        settings: settings
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
        reducer: AppFeature.reducer,
        dependencies: dependencies
    )
}
