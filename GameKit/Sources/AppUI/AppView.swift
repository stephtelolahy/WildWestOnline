//
//  MainView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable type_contents_order

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
            if let state = store.state.screens.last {
                viewForState(state)
            } else {
                EmptyView()
            }
        }
        .foregroundColor(.primary)
    }

    private func viewForState(_ state: ScreenState) -> some View {
        Group {
            switch state {
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
                        GamePlayState.from(globalState: $0)
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
    }
}

#Preview {
    AppView {
        Store<AppState>(initial: .init(screens: [.splash(.init())]))
    }
}

private extension GamePlayState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case let .game(gameState) = lastScreen else {
            return nil
        }

        return gameState
    }
}

extension HomeState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case let .home(homeState) = lastScreen else {
            return nil
        }

        return homeState
    }
}

private extension SplashState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case let .splash(splashState) = lastScreen else {
            return nil
        }

        return splashState
    }
}

private extension SettingsState {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}
