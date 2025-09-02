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
    @ObservedObject private var store: Store<AppFeature.State, AppFeature.Dependencies>
    @State private var path: [SettingsNavigationFeature.State.Destination] = []

    public init(store: Store<AppFeature.State, AppFeature.Dependencies>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $path) {
            SettingsRootView { store.projection(SettingsRootView.ViewState.init) }
                .navigationDestination(for: SettingsNavigationFeature.State.Destination.self) {
                    viewForDestination($0)
                }
        }
        // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
        .onReceive(store.$state) { state in
            guard let newPath = state.navigation.settingsSheet?.path else { return }
            path = newPath
        }
        .onChange(of: path) { _, newPath in
            guard newPath != store.state.navigation.settingsSheet?.path else { return }
            Task {
                await store.dispatch(SettingsNavigationFeature.Action.setPath(newPath))
            }
        }
        .presentationDetents([.medium, .large])
    }

    @ViewBuilder private func viewForDestination(_ destination: SettingsNavigationFeature.State.Destination) -> some View {
        switch destination {
        case .figures: SettingsFiguresView { store.projection(SettingsFiguresView.ViewState.init) }
        }
    }
}

#Preview {
    SettingsCoordinator(
        store: Store<AppFeature.State, AppFeature.Dependencies>(
            initialState: .mock,
            dependencies: .init(settings: .init())
        )
    )
}

private extension AppFeature.State {
    static var mock: Self {
        .init(
            navigation: .init(),
            settings: .makeBuilder().build(),
            inventory: .makeBuilder().build()
        )
    }
}
