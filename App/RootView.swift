//
//  RootView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

import SwiftUI
import NavigationCore
import Redux
import AppCore
import SplashUI
import SettingsUI
import HomeUI
import GameUI

struct RootView: View {
    @StateObject private var store: Store<AppState, Any>

    init(store: @escaping () -> Store<AppState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        NavigationStackView(
            store: {
                store.projection(using: RootViewConnector())
            },
            root: {
                SplashViewAssembly.buildSplashView(store)
            },
            destination:  { destination in
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

                content.eraseToAnyView()
            }
        )
    }
}

#Preview {
    RootView(store: .init(initial: .mockedData))
}

private extension AppState {
    static var mockedData: Self {
        .init(
            navigation: .init(),
            settings: .makeBuilder().build(),
            inventory: .makeBuilder().build()
        )
    }
}

private struct RootViewConnector: Connector {
    func deriveState(_ state: AppState) -> NavigationStackState<RootDestination>? {
        state.navigation.root
    }

    func embedAction(_ action: NavigationStackAction<RootDestination>) -> Any {
        action
    }
}
