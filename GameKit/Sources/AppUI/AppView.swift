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
