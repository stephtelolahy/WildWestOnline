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
    @StateObject private var store: Store<NavigationStackState<RootDestination>, NavigationAction<RootDestination>>
    private let coordinator: Coordinator

    init(
        store: @escaping () -> Store<NavigationStackState<RootDestination>, NavigationAction<RootDestination>>,
        coordinator: Coordinator
    ) {
        _store = StateObject(wrappedValue: store())
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: pathBinding) {
            coordinator.start()
                .navigationDestination(for: RootDestination.self) { destination in
                    coordinator.view(for: destination)
                }
                .sheet(item: sheetBinding) { destination in
                    coordinator.view(for: destination)
                }
        }
    }

    private var pathBinding: Binding<[RootDestination]> {
        .init(
            get: { store.state.path },
            set: { _ in }
        )
    }

    private var sheetBinding: Binding<RootDestination?> {
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
                store.projection(using: SplashViewConnector())
            }
        }

        @MainActor func view(for destination: RootDestination) -> some View {
            switch destination {
            case .home:
                HomeView {
                    store.projection(using: HomeViewConnector())
                }

            case .game:
                GameView {
                    store.projection(using: GameViewConnector())
                }

            case .settings:
                SettingsCoordinatorView(
                    store: {
                        store.projection(using: SettingsNavViewConnector())
                    },
                    coordinator: .init(store: store)
                )
            }
        }
    }
}

struct RootViewConnector: Connector {
    func deriveState(_ state: AppState) -> NavigationStackState<RootDestination>? {
        state.navigation.root
    }

    func embedAction(_ action: NavigationAction<RootDestination>, _ state: AppState) -> Any {
        action
    }
}
