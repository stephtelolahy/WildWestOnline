//
//  RootCoordinatorView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//

import SwiftUI
import Redux
import AppCore
import NavigationCore
import SplashUI
import HomeUI
import GameUI

struct RootCoordinatorView: View {
    @StateObject private var store: Store<RootNavigationState, RootNavigationAction>
    private let coordinator: Coordinator

    init(
        store: @escaping () -> Store<RootNavigationState, RootNavigationAction>,
        coordinator: Coordinator
    ) {
        _store = StateObject(wrappedValue: store())
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: pathBinding) {
            coordinator.start()
                .navigationDestination(for: RootNavigationState.Destination.self) { destination in
                    coordinator.view(for: destination)
                }
                .sheet(item: sheetBinding) { destination in
                    coordinator.view(for: destination)
                }
        }
    }

    private var pathBinding: Binding<[RootNavigationState.Destination]> {
        .init(
            get: { store.state.path },
            set: { _ in }
        )
    }

    private var sheetBinding: Binding<RootNavigationState.Destination?> {
        .init(
            get: { store.state.sheet },
            set: { _ in }
        )
    }
}

extension RootCoordinatorView {
    struct Coordinator: @preconcurrency ViewCoordinator {
        let store: Store<AppState, Any>

        @MainActor func start() -> some View {
            SplashView {
                store.projection(using: SplashView.Connector())
            }
        }

        @MainActor func view(for destination: RootNavigationState.Destination) -> some View {
            switch destination {
            case .home:
                HomeView {
                    store.projection(using: HomeView.Connector())
                }

            case .game:
                GameView {
                    store.projection(using: GameView.Connector())
                }

            case .settings:
                SettingsCoordinatorView(
                    store: {
                        store.projection(using: SettingsCoordinatorView.Connector())
                    },
                    coordinator: .init(store: store)
                )
            }
        }
    }

    struct Connector: Redux.Connector {
        func deriveState(_ state: AppState) -> RootNavigationState? {
            state.navigation.root
        }

        func embedAction(_ action: RootNavigationAction, _ state: AppState) -> Any {
            action
        }
    }
}
