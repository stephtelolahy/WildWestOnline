//
//  MainView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable type_contents_order

import Redux
import GameUI
import HomeUI
import ScreenSplash
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

            case .splash:
                SplashView {
                    store.projection {
                        SplashState.from(globalState: $0)
                    }
                }

            case nil:
                EmptyView()
            }
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    AppView {
        Store<AppState>(initial: .init(screens: [.splash(.init())]))
    }
}
