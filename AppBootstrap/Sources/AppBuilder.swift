//
//  AppBuilder.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
import SwiftUI
import Redux
import AppCore
import SettingsFeature
import SettingsClient
import SettingsClientLive
import GameFeature
import GameData
import AudioClient
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

        let audioClient = AudioClient.live()
        Task {
            await audioClient.setMusicVolume(settingsClient.musicVolume())
            await audioClient.load(AudioClient.Sound.allSfx)
            await audioClient.play(AudioClient.Sound.musicLoneRider)
        }

        let store = Store<AppFeature.State, AppFeature.Action, AppFeature.Dependencies>(
            initialState: appState,
            reducer: AppFeature.reducer,
            dependencies: .init(
                settingsClient: settingsClient,
                audioClient: audioClient
            )
        )

        return AppCoordinator {
            store
        }
    }
}
