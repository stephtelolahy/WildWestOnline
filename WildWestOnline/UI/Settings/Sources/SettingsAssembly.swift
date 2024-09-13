//
//  SettingsAssembly.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//
import SwiftUI
import AppCore
import NavigationCore
import Redux

public enum SettingsAssembly {
    public static func buildSettingsNavigationView(_ store: Store<AppState, Any>) -> some View {
        CoordinatorView<SettingsDestination>(
            store: {
                store.projection(using: SettingsCoordinatorViewConnector())
            },
            coordinator: SettingsCoordinator(store: store)
        )
    }
}
