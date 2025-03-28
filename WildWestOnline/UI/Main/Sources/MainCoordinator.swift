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
    @StateObject private var store: Store<AppFeature.State, AppFeature.Dependencies>
    @State private var path: [NavigationFeature.State.MainDestination] = []
    @State private var sheet: NavigationFeature.State.MainDestination? = nil

    public init(store: @escaping () -> Store<AppFeature.State, AppFeature.Dependencies>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationStack(path: $path) {
            SplashView { store.projection(SplashView.State.init) }
                .navigationDestination(for: NavigationFeature.State.MainDestination.self) {
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
                        await store.dispatch(NavStackFeature<NavigationFeature.State.MainDestination>.Action.setPath(newPath))
                    }
                }
                .onChange(of: sheet) { _, newSheet in
                    guard newSheet != store.state.navigation.mainStack.sheet else { return }
                    Task {
                        if let newSheet {
                            await store.dispatch(NavStackFeature<NavigationFeature.State.MainDestination>.Action.present(newSheet))
                        } else {
                            await store.dispatch(NavStackFeature<NavigationFeature.State.MainDestination>.Action.dismiss)
                        }
                    }
                }
        }
    }

    @ViewBuilder private func viewForDestination(_ destination: NavigationFeature.State.MainDestination) -> some View {
        switch destination {
        case .home: HomeView { store.projection(HomeView.State.init) }
        case .game: GameView { store.projection(GameView.State.init) }
        case .settings: SettingsCoordinator(store: store)
        }
    }
}

#Preview {
    MainCoordinator {
        Store<AppFeature.State, AppFeature.Dependencies>.init(
            initialState: .mock,
            dependencies: .init(settings: .init())
        )
    }
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
