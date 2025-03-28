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
    @State private var path: [Navigation.State.MainDestination] = []
    @State private var sheet: Navigation.State.MainDestination? = nil

    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            SplashView { store.projection(SplashView.State.init) }
                .navigationDestination(for: Navigation.State.MainDestination.self) {
                viewForDestination($0)
            }
            .sheet(item: $sheet) {
                viewForDestination($0)
            }
            // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
            .onReceive(store.$state) { state in
                path = state.navigation.mainStack.path
                sheet = state.navigation.mainStack.sheet
            }
            .onChange(of: path) { _, newPath in
                guard newPath != store.state.navigation.mainStack.path else { return }
                Task {
                    await store.dispatch(NavigationCore.NavigationStack<Navigation.State.MainDestination>.Action.setPath(newPath))
                }
            }
            .onChange(of: sheet) { _, newSheet in
                guard newSheet != store.state.navigation.mainStack.sheet else { return }
                Task {
                    if let newSheet {
                        await store.dispatch(NavigationCore.NavigationStack<Navigation.State.MainDestination>.Action.present(newSheet))
                    } else {
                        await store.dispatch(NavigationCore.NavigationStack<Navigation.State.MainDestination>.Action.dismiss)
                    }
                }
            }
        }
    }

    @ViewBuilder private func viewForDestination(_ destination: Navigation.State.MainDestination) -> some View {
    switch destination {
    case .home: HomeView { store.projection(HomeView.State.init) }
    case .game: GameView { store.projection(GameView.State.init) }
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
