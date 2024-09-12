//
//  RootCoordinator.swift
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

struct RootCoordinator {
    let store: Store<AppState, Any>

    @MainActor func startView() -> AnyView {
        SplashView {
            store.projection(using: SplashViewConnector())
        }
        .eraseToAnyView()
    }

    @MainActor func view(for destination: RootDestination) -> AnyView {
        let content = switch destination {
        case .home:
            HomeView {
                store.projection(using: HomeViewConnector())
            }
            .eraseToAnyView()

        case .game:
            GameView {
                store.projection(using: GameViewConnector(controlledPlayerId: store.state.game!.round.startOrder.first!))
            }
            .eraseToAnyView()

        case .settings:
            CoordinatorView<SettingsDestination>(
                store: {
                    store.projection(using: SettingsCoordinatorViewConnector())
                },
                startView: { SettingsCoordinator(store: store).startView() },
                destinationView: { SettingsCoordinator(store: store).view(for: $0) }
            )
            .eraseToAnyView()
        }

        return content.eraseToAnyView()
    }
}

struct RootCoordinatorViewConnector: Connector {
    func deriveState(_ state: AppState) -> NavigationStackState<RootDestination>? {
        state.navigation.root
    }

    func embedAction(_ action: NavigationAction<RootDestination>) -> Any {
        action
    }
}
