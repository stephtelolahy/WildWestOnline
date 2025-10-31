//
//  AppBuilder.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
import SwiftUI
import Redux
import AppCore
import SettingsCore
import SettingsClient
import SettingsClientLive
import GameCore
import GameData
import AudioPlayer
import AppUI

@MainActor
public enum AppBuilder {
    public static func build() -> some View {
        let settingsClient = SettingsClient.live()

        let settingsState = SettingsFeature.State.makeBuilder()
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

        let appState = AppFeature.State(
            inventory: inventory,
            navigation: .init(),
            settings: settingsState
        )

        let audioPlayer = AudioPlayer.live()
        Task {
            await audioPlayer.setMusicVolume(settingsClient.musicVolume())
            await audioPlayer.load(AudioPlayer.Sound.allSfx)
            await audioPlayer.play(AudioPlayer.Sound.musicLoneRider)
        }

        let store = Store<AppFeature.State, AppFeature.Action, AppFeature.Dependencies>(
            initialState: appState,
            reducer: AppFeature.reducer,
            dependencies: .init(
                settings: settingsClient,
                audioPlayer: audioPlayer
            )
        )

        return AppCoordinator {
            store
        }
    }
}
