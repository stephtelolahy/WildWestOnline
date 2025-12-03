//
//  AppBuilder.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
import SwiftUI
import Redux
import AppFeature
import SettingsFeature
import PreferencesClient
import PreferencesClientLive
import GameFeature
import CardResources
import AudioClient
import AudioClientLive
import AppUI

@MainActor
public enum AppBuilder {
    public static func build() -> some View {
        let preferencesClient = PreferencesClient.live()

        let settingsState = SettingsFeature.State.makeBuilder()
            .withPlayersCount(preferencesClient.playersCount())
            .withActionDelayMilliSeconds(preferencesClient.actionDelayMilliSeconds())
            .withSimulation(preferencesClient.isSimulationEnabled())
            .withPreferredFigure(preferencesClient.preferredFigure())
            .withMusicVolume(preferencesClient.musicVolume())
            .build()

        let cardLibrary = AppFeature.State.CardLibrary(
            cards: Cards.all,
            deck: Deck.all,
            specialSounds: SFX.specialSounds
        )

        let appState = AppFeature.State(
            cardLibrary: cardLibrary,
            navigation: .init(),
            settings: settingsState
        )

        let audioClient = AudioClient.live()
        Task {
            await audioClient.setMusicVolume(preferencesClient.musicVolume())
            await audioClient.load(AudioClient.Sound.allSfx)
            await audioClient.play(AudioClient.Sound.musicLoneRider)
        }

        let modifierClient = QueueModifierClient.live(handlers: QueueModifiers.allHandlers)

        let store = Store<AppFeature.State, AppFeature.Action, AppFeature.Dependencies>(
            initialState: appState,
            reducer: AppFeature.reducer,
            dependencies: .init(
                preferencesClient: preferencesClient,
                audioClient: audioClient,
                modifierClient: modifierClient
            )
        )

        return AppCoordinator {
            store
        }
    }
}
