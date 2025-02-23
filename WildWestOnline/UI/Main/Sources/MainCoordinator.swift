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
            SplashContainerView()
                .navigationDestination(for: MainDestination.self) {
                    viewForDestination($0)
                }
                .sheet(item: $sheet) {
                    viewForDestination($0)
                }
                // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
                .onChange(of: store.state) { _ in
                    path = store.state.navigation.main.path
                    sheet = store.state.navigation.main.sheet
                }
        }
    }

    @ViewBuilder private func viewForDestination(_ destination: MainDestination) -> some View {
        switch destination {
        case .home: HomeContainerView()
        case .game: GameContainerView()
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
