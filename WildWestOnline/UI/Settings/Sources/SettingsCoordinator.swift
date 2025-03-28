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
    @State private var path: [Navigation.State.SettingsDestination] = []

    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            SettingsRootView { store.projection(SettingsRootView.State.init) }
                .navigationDestination(for: Navigation.State.SettingsDestination.self) {
                    viewForDestination($0)
                }
                // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
                .onReceive(store.$state) { state in
                    path = state.navigation.settingsStack.path
                }
                .onChange(of: path) { _, newPath in
                    guard newPath != store.state.navigation.settingsStack.path else { return }
                    Task {
                        await store.dispatch(NavigationCore.NavigationStack<Navigation.State.SettingsDestination>.Action.setPath(newPath))
                    }
                }
        }
    }

    @ViewBuilder private func viewForDestination(_ destination: Navigation.State.SettingsDestination) -> some View {
        switch destination {
        case .figures: SettingsFiguresView { store.projection(SettingsFiguresView.State.init) }
        }
    }
}
