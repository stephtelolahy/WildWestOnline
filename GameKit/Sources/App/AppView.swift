//
//  MainView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable type_contents_order no_magic_numbers

import Game
import GameUI
import HomeUI
import Redux
import SettingsUI
import SplashUI
import SwiftUI

public struct AppView: View {
    @StateObject private var store: Store<AppState>

    public init(store: @escaping () -> Store<AppState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        Group {
            switch store.state.screen {
            case .splash:
                SplashView {
                    store.projection {
                        SplashState.from(globalState: $0)
                    }
                }

            case .home:
                HomeView {
                    store.projection {
                        HomeState.from(globalState: $0)
                    }
                }

            case .game:
                GamePlayView {
                    store.projection {
                        GameState.from(globalState: $0)
                    }
                }

            case .settings:
                SettingsView {
                    store.projection {
                        SettingsState.from(globalState: $0)
                    }
                }
            }
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    AppView {
        Store<AppState>(
            initial: .init(
                screen: .splash,
                settings: .init(playersCount: 5, simulation: false)
            )
        )
    }
}
