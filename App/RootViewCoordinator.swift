//
//  RootViewCoordinator.swift
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

struct RootViewCoordinator: @preconcurrency ViewCoordinator {
    let store: Store<AppState, Any>

    @MainActor func start() -> some View {
        SplashView {
            store.projection(SplashView.deriveState, SplashView.embedAction)
        }
    }

    @MainActor func view(for destination: RootNavigationState.Destination) -> some View {
        switch destination {
        case .home:
            HomeView {
                store.projection(HomeView.deriveState, HomeView.embedAction)
            }

        case .game:
            GameView {
                store.projection(GameView.deriveState, GameView.embedAction)
            }

        case .settings:
            fatalError()
        }
    }
}
