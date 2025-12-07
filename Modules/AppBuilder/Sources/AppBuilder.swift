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
        var dependencies = Dependencies()
        dependencies.preferencesClient = PreferencesClient.live()
        dependencies.audioClient = AudioClient.live()
        dependencies.queueModifierClient = QueueModifierClient.live(handlers: QueueModifiers.allHandlers)
        dependencies.cardLibrary = CardLibrary.live()

        let store = Store<AppFeature.State, AppFeature.Action>(
            initialState: .init(),
            reducer: AppFeature.reducer,
            dependencies: dependencies
        )

        return AppView {
            store
        }
    }
}
