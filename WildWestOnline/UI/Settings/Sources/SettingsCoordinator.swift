//
//  SettingsCoordinator.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux
import SwiftUI
import AppCore
import NavigationCore

public struct SettingsCoordinator: View {
    @EnvironmentObject private var store: Store<AppState, AppDependencies>
    @State private var path: [SettingsDestination] = []

    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            SettingsRootContainerView()
                .navigationDestination(for: SettingsDestination.self) {
                    viewForDestination($0)
                }
                // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
                .onChange(of: store.state) { _ in
                    path = store.state.navigation.settings.path
                }
        }
    }

    @ViewBuilder private func viewForDestination(_ destination: SettingsDestination) -> some View {
        switch destination {
        case .figures: SettingsFiguresContainerView()
        }
    }
}
