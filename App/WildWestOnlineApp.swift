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
        }
    }
}

@MainActor private func createStore() -> Store<AppFeature.State, AppFeature.Action, AppFeature.Dependencies> {
    let settingsService = SettingsRepository()
    let settingsDependency = SettingsFeature.Dependencies(
        savePlayersCount: settingsService.savePlayersCount,
        saveActionDelayMilliSeconds: settingsService.saveActionDelayMilliSeconds,
        saveSimulationEnabled: settingsService.saveSimulationEnabled,
        savePreferredFigure: settingsService.savePreferredFigure
    )

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

    let audioPlayer = AudioPlayer.shared
    Task {
        await audioPlayer.load(AudioPlayer.Sound.allSfx)
    }

    return Store(
        initialState: initialState,
        reducer: AppFeature.reducer,
        dependencies: .init(
            settings: settingsDependency,
            audioPlayer: audioPlayer
        )
    )
}
