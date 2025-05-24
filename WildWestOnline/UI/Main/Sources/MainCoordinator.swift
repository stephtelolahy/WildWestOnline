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
import SettingsUI
import HomeUI
import GameUI

public struct MainCoordinator: View {
    @StateObject private var store: Store<AppFeature.State, AppFeature.Dependencies>
    @State private var path: [MainNavigationFeature.State.Destination] = []
    @State private var settingsSheetPresented: Bool = false

    public init(store: @escaping () -> Store<AppFeature.State, AppFeature.Dependencies>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                viewState: { store.projection(HomeView.ViewState.init) },
                onNavigateToGame: { path.append(.game) },
                onPresentSettings: { settingsSheetPresented = true }
            )
            .navigationDestination(for: MainNavigationFeature.State.Destination.self) { destination in
                viewForDestination(destination)
            }
        }
        .sheet(isPresented: $settingsSheetPresented) {
            SettingsCoordinator(
                store: store,
                onDismiss: { settingsSheetPresented = false }
            )
        }
        .onReceive(store.$state) { state in
            // Keep other state in sync if needed, but navigation is now local
        }
        .onReceive(store.dispatchedAction) { event in
            print(event)
        }
    }

    @ViewBuilder private func viewForDestination(_ destination: MainNavigationFeature.State.Destination) -> some View {
        switch destination {
        case .game:
            GameView(
                viewState: { store.projection(GameView.ViewState.init) },
                onNavigateBack: { path.removeLast() }
            )
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
