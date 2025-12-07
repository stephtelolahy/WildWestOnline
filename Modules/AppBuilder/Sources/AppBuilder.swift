//
//  AppBuilder.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
import SwiftUI
import Redux
import AppFeature
import PreferencesClient
import PreferencesClientLive
import AudioClient
import AudioClientLive
import CardLibrary
import CardLibraryLive
import GameFeature

@MainActor
public enum AppBuilder {
    public static func build() -> some View {
        let preferencesClient = PreferencesClient.live()
        let cardLibrary = CardLibrary.live()
        let audioClient = AudioClient.live()
        let queueModifierClient = QueueModifierClient.live(handlers: QueueModifiers.allHandlers)

        var dependencies = Dependencies()
        dependencies.preferencesClient = preferencesClient
        dependencies.audioClient = audioClient
        dependencies.queueModifierClient = queueModifierClient

        let store = Store<AppFeature.State, AppFeature.Action>(
            initialState: .init(),
            reducer: AppFeature.reducer,
            dependencies: dependencies
        )

        return AppView {
            store
        }
        .task {
            await audioClient.setMusicVolume(preferencesClient.musicVolume())
            await audioClient.load(AudioClient.Sound.allSfx)
        }
    }
}
