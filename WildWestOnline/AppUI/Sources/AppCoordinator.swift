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
    public typealias ViewStore = Store<AppFeature.State, AppFeature.Action, AppFeature.Dependencies>
    @StateObject private var store: ViewStore
    @State private var path: [AppNavigationFeature.State.Destination] = []
    @State private var settingsSheetPresented: Bool = false

    public init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationStack(path: $path) {
            HomeView { store.projection(state: HomeView.ViewState.init, action: \.self) }
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
                await store.dispatch(.navigation(.setPath(newPath)))
            }
        }
        .onChange(of: settingsSheetPresented) { _, isPresented in
            guard isPresented != (store.state.navigation.settingsSheet != nil) else {
                return
            }

            Task {
                if isPresented {
                    await store.dispatch(.navigation(.presentSettingsSheet))
                } else {
                    await store.dispatch(.navigation(.dismissSettingsSheet))
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
            GameView { store.projection(state: GameView.ViewState.init, action: \.self) }
        }
    }
}

#Preview {
    AppCoordinator {
        Store(
            initialState: .mock,
            dependencies: .init(settings: .init())
        )
    }
}

private extension AppFeature.State {
    static var mock: Self {
        .init(
            inventory: .makeBuilder().build(),
            navigation: .init(),
            settings: .makeBuilder().build()
        )
    }
}
