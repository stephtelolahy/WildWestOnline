//
//  AppCoordinator.swift
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
import Redux
import Combine

/// The `ObservableObject driving a `CoordinatorView`
final class AppCoordinator: ObservableObject, @unchecked Sendable {
    @Published var path: [Page] = []
    @Published var sheet: Page?
    private let store: Store<AppState, Any>

    init(globalStore: Store<AppState, Any>) {
        self.store = globalStore

        globalStore.$state
            .map(\.navigation.path)
            .removeDuplicates()
            .assign(to: &self.$path)

        globalStore.$state
            .map(\.navigation.sheet)
            .removeDuplicates()
            .assign(to: &self.$sheet)
    }

    @MainActor @ViewBuilder
    func build(page: Page) -> some View {
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
            SettingsCoordinatorView { [self] in
                SettingsCoordinator(store: store)
            }
        }
    }
}
