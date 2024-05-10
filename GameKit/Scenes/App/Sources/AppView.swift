//
//  MainView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable type_contents_order

import AppCore
import GamePlay
import Home
import Redux
import Settings
import SettingsCore
import Splash
import SwiftUI

public struct AppView: View {
    @StateObject private var store: Store<AppState>

    public init(store: @escaping () -> Store<AppState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        Group {
            switch store.state.screens.last {
            case .splash:
                SplashView {
                    store.projection(using: Connectors.SplashViewConnector())
                }

            case .home:
                HomeView {
                    store.projection(using: Connectors.HomeViewConnector())
                }

            case .game:
                gamePlayView

            default:
                EmptyView()
            }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { store.state.screens.last == .settings },
            set: { _ in }
        ), onDismiss: {
        }, content: {
            SettingsView {
                store.projection(using: Connectors.SettingsViewConnector())
            }
        })
        .foregroundColor(.primary)
    }

    private var gamePlayView: some View {
        Group {
            switch store.state.settings.gamePlay {
            case 0:
                GamePlayUIKitView {
                    store.projection(using: Connectors.GamePlayUIKitViewConnector())
                }

            case 1:
                GamePlayView {
                    store.projection(using: Connectors.GamePlayViewConnector())
                }

            default:
                fatalError("unexpected")
            }
        }
    }
}

#Preview {
    AppView {
        Store(initial: .mock)
    }
}

private extension AppState {
    static var mock: Self {
        .init(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
    }
}
