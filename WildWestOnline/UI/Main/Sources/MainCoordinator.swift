//
//  MainCoordinator.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

import SwiftUI
import NavigationCore
import Redux
import AppCore
import SplashUI
import SettingsUI
import HomeUI
import GameUI

public struct MainCoordinator: View {
    @EnvironmentObject private var store: Store<AppState, AppDependencies>
    @State private var path: [MainDestination] = []
    @State private var sheet: MainDestination? = nil

    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            SplashView { store.projection { SplashView.State(appState: $0) } }
            .navigationDestination(for: MainDestination.self) {
                viewForDestination($0)
            }
            .sheet(item: $sheet) {
                viewForDestination($0)
            }
            // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
            .onReceive(store.$state) { state in
                path = state.navigation.main.path
                sheet = state.navigation.main.sheet
            }
            .onChange(of: path) { _, newPath in
                guard newPath != store.state.navigation.main.path else { return }
                Task {
                    await store.dispatch(NavigationStackAction<MainDestination>.setPath(newPath))
                }
            }
            .onChange(of: sheet) { oldSheet, newSheet in
                guard newSheet != store.state.navigation.main.sheet else { return }
                Task {
                    await store.dispatch(NavigationStackAction<MainDestination>.pop)
                }
            }
        }
    }

@ViewBuilder private func viewForDestination(_ destination: MainDestination) -> some View {
    switch destination {
    case .home: HomeView { store.projection { HomeView.State(appState: $0) } }
    case .game: GameView { store.projection { GameView.State(appState: $0) } }
    case .settings: SettingsCoordinator()
    }
}
}

#Preview {
    MainCoordinator()
        .environmentObject(
            Store<AppState, AppDependencies>.init(
                initialState: .mock,
                dependencies: .mock
            )
        )
}

private extension AppState {
    static var mock: Self {
        .init(
            navigation: .init(),
            settings: .makeBuilder().build(),
            inventory: .makeBuilder().build()
        )
    }
}

private extension AppDependencies {
    static var mock: Self {
        .init(
            settings: .init(
                savePlayersCount: { _ in },
                saveActionDelayMilliSeconds: { _ in },
                saveSimulationEnabled: { _ in },
                savePreferredFigure: { _ in }
            )
        )
    }
}
