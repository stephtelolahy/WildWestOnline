//
//  WildWestOnlineApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import AppCore
import CardsData
import GameCore
import Redux
import SettingsCore
import SettingsData
import NavigationCore
import SwiftUI
import Theme
import SplashUI
import SettingsUI
import HomeUI
import GameUI

@main
struct WildWestOnlineApp: App {
    @Environment(\.theme) private var theme

    var body: some Scene {
        WindowGroup {
            RootViewAssembly.buildRootView(createAppStore())
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

private func createAppStore() -> Store<AppState, Any> {
    let settingsService = SettingsRepository()
    let cardsService = CardsRepository()

    let settings = SettingsState.makeBuilder()
        .withPlayersCount(settingsService.playersCount())
        .withWaitDelayMilliseconds(settingsService.waitDelayMilliseconds())
        .withSimulation(settingsService.isSimulationEnabled())
        .withPreferredFigure(settingsService.preferredFigure())
        .build()

    let initialState = AppState(
        navigation: .init(),
        settings: settings,
        inventory: cardsService.inventory
    )

    return Store<AppState, Any>(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
            Middlewares.lift(
                Middlewares.updateGame(),
                deriveState: { $0.game },
                deriveAction: { $0 as? GameAction },
                embedAction: { $0 }
            ),
            Middlewares.lift(
                Middlewares.saveSettings(with: settingsService),
                deriveState: { $0.settings },
                deriveAction: { $0 as? SettingsAction },
                embedAction: { $0 }
            ),
            Middlewares.logger()
        ]
    )
}

private enum RootViewAssembly {
    @MainActor static func buildRootView(_ store: Store<AppState, Any>) -> some View {
        CoordinatorView(
            store: {
                store.projection(using: RootCoordinatorViewConnector())
            },
            coordinator: RootCoordinator(store: store)
        )
    }
}

private struct RootCoordinator: @preconcurrency Coordinator {
    let store: Store<AppState, Any>

    @MainActor func startView() -> AnyView {
        SplashViewAssembly.buildSplashView(store)
        .eraseToAnyView()
    }

    @MainActor func view(for destination: RootDestination) -> AnyView {
        let content = switch destination {
        case .home:
            HomeViewAssembly.buildHomeView(store)
            .eraseToAnyView()

        case .game:
            GameViewAssembly.buildGameView(store)
            .eraseToAnyView()

        case .settings:
            SettingsAssembly.buildSettingsNavigationView(store)
            .eraseToAnyView()
        }

        return content.eraseToAnyView()
    }
}

private struct RootCoordinatorViewConnector: Connector {
    func deriveState(_ state: AppState) -> NavigationStackState<RootDestination>? {
        state.navigation.root
    }

    func embedAction(_ action: NavigationAction<RootDestination>) -> Any {
        action
    }
}
