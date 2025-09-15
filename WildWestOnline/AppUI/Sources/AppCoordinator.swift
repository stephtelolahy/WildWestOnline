//
//  AppCoordinator.swift
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

public struct AppCoordinator: View {
    @StateObject private var store: Store<AppFeature.State, AppFeature.Dependencies>
    @State private var path: [AppNavigationFeature.State.Destination] = []
    @State private var settingsSheetPresented: Bool = false

    public init(store: @escaping () -> Store<AppFeature.State, AppFeature.Dependencies>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationStack(path: $path) {
            HomeView { store.projection(HomeView.ViewState.init) }
                .navigationDestination(for: AppNavigationFeature.State.Destination.self) {
                    viewForDestination($0)
                }
        }
        .sheet(isPresented: $settingsSheetPresented) {
            SettingsCoordinator(store: store)
        }
        // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
        .onReceive(store.$state) { state in
            path = state.navigation.path
            settingsSheetPresented = state.navigation.settingsSheet != nil
        }
        .onChange(of: path) { _, newPath in
            guard newPath != store.state.navigation.path else {
                return
            }

            Task {
                await store.dispatch(AppNavigationFeature.Action.setPath(newPath))
            }
        }
        .onChange(of: settingsSheetPresented) { _, isPresented in
            guard isPresented != (store.state.navigation.settingsSheet != nil) else {
                return
            }

            Task {
                if isPresented {
                    await store.dispatch(AppNavigationFeature.Action.presentSettingsSheet)
                } else {
                    await store.dispatch(AppNavigationFeature.Action.dismissSettingsSheet)
                }
            }
        }
        .onReceive(store.dispatchedAction) { event in
            print(event)
        }
    }

    @ViewBuilder private func viewForDestination(_ destination: AppNavigationFeature.State.Destination) -> some View {
        switch destination {
        case .game:
            GameView { store.projection(GameView.ViewState.init) }
        }
    }
}

#Preview {
    AppCoordinator {
        Store<AppFeature.State, AppFeature.Dependencies>(
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
