//
//  MainView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable prefixed_toplevel_constant type_contents_order

import Redux
import ScreenGame
import ScreenHome
import SwiftUI

public struct AppView: View {
    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        Group {
            switch store.state.screens.last {
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

            default:
                SplashView()
            }
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    AppView()
        .environmentObject(previewStore)
}

private let previewStore = Store<AppState>(initial: .init(screens: [.splash]))

private extension GamePlayState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
           case let .game(gameState) = lastScreen else {
            return nil
        }

        return gameState
    }
}

private extension HomeState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
           case let .home(homeState) = lastScreen else {
            return nil
        }

        return homeState
    }
}
