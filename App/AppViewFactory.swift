//
//  AppViewFactory.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 08/09/2024.
//
import SwiftUI
import Redux
import AppCore
import NavigationCore
import SplashUI
import SettingsUI
import HomeUI
import GameUI

struct AppViewFactory: @preconcurrency ViewFactory {
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
            CoordinatorView(
                pathBinding: .init(
                    get: { store.state.navigation.settingsPath },
                    set: { _ in }
                ),
                sheetBinding: .init(
                    get: { nil },
                    set: { _ in }
                ),
                viewFactory: self
            )

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
