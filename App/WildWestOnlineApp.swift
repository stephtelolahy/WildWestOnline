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
import SettingsClient
import SettingsClientLive
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
    let settingsClient = SettingsClient.live()

    let settings = SettingsFeature.State.makeBuilder()
        .withPlayersCount(settingsClient.playersCount())
        .withActionDelayMilliSeconds(settingsClient.actionDelayMilliSeconds())
        .withSimulation(settingsClient.isSimulationEnabled())
        .withPreferredFigure(settingsClient.preferredFigure())
        .withMusicVolume(settingsClient.musicVolume())
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

    let audioPlayer = AudioPlayer.live()
    Task {
        await audioPlayer.setMusicVolume(settingsClient.musicVolume())
        await audioPlayer.load(AudioPlayer.Sound.allSfx)
        await audioPlayer.play(AudioPlayer.Sound.musicLoneRider)
    }

    return Store(
        initialState: initialState,
        reducer: AppFeature.reducer,
        dependencies: .init(
            settings: settingsClient,
            audioPlayer: audioPlayer
        )
    )
}
