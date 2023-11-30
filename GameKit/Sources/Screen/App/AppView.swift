//
//  MainView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable prefixed_toplevel_constant type_contents_order

import Redux
import ScreenGame
import SwiftUI

public struct AppView: View {
    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        Group {
            switch store.state.screens.last {
            case .home:
                HomeView()

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

extension GamePlayState {
    static func from(globalState: AppState) -> GamePlayState? {
        guard let lastScreen = globalState.screens.last,
           case let .game(gameState) = lastScreen else {
            return nil
        }

        return gameState
    }
}
