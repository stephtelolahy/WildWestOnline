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
    @StateObject private var store = createAppStore()

    var body: some Scene {
        WindowGroup {
            CoordinatorView(viewFactory: AppViewFactory(store: store), store: {
                store.projection(
                    WildWestOnlineApp.deriveState,
                    WildWestOnlineApp.embedAction
                )
            })
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

private extension WildWestOnlineApp {
    static let deriveState: (AppState) -> NavigationState? = { state in
        state.navigation
    }

    static let embedAction: (CoordinatorView.Action, AppState) -> Any = { action, _ in
        NavigationAction.dismiss
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
        navigation: .init(path: [.splash]),
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
                embedAction: { action, _ in action }
            ),
            Middlewares.lift(
                Middlewares.saveSettings(with: settingsService),
                deriveState: { $0.settings },
                deriveAction: { $0 as? SettingsAction },
                embedAction: { action, _ in action }
            ),
            Middlewares.logger()
        ]
    )
}

@preconcurrency struct AppViewFactory: ViewFactory {
    let store: Store<AppState, Any>

    @MainActor
    func build(page: Page) -> AnyView {
        AnyView(buildSomeView(page: page))
    }

    @MainActor @ViewBuilder
    private func buildSomeView(page: Page) -> some View {
        switch page {
        case .splash:
            SplashView { [self] in
                store.projection(SplashView.deriveState, SplashView.embedAction)
            }

        case .home:
            HomeView { [self] in
                store.projection(HomeView.deriveState, HomeView.embedAction)
            }

        case .game:
            GameView { [self] in
                store.projection(GameView.deriveState, GameView.embedAction)
            }

        case .settings:
            fatalError()
            //            CoordinatorView(
            //                root: .settingsMain,
            //                pathBinding: .init(
            //                    get: { store.state.navigation.settingsPath },
            //                    set: { _ in }
            //                ),
            //                sheetBinding: .init(
            //                    get: { nil },
            //                    set: { _ in }
            //                ),
            //                viewFactory: self
            //            )

        case .settingsMain:
            SettingsView { [self] in
                store.projection(SettingsView.deriveState, SettingsView.embedAction)
            }

        case .settingsFigure:
            FiguresView { [self] in
                store.projection(FiguresView.deriveState, FiguresView.embedAction)
            }
        }
    }
}
