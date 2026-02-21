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
import GameCore

@MainActor
public enum AppBuilder {
    public static func build() -> some View {
        let store = Store<AppFeature.State, AppFeature.Action>(
            initialState: .init(),
            reducer: AppFeature.reducer,
            withDependencies: {
                $0.preferencesClient = PreferencesClient.live()
                $0.audioClient = AudioClient.live()
                $0.queueModifierClient = QueueModifierClient.live(handlers: QueueModifiers.allHandlers)
                $0.cardLibrary = CardLibrary.live()
            }
        )

        return AppView {
            store
        }
    }
}
