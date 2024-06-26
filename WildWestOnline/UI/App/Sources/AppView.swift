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
                    store.projection(SplashView.deriveState)
                }

            case .home:
                HomeView {
                    store.projection(HomeView.deriveState)
                }

            case .game:
                GamePlayView {
                    store.projection(GamePlayView.deriveState)
                }

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
                store.projection(SettingsView.deriveState)
            }
        })
        .foregroundColor(.primary)
    }
}

#Preview {
    AppView {
        Store(initial: .sample)
    }
}

private extension AppState {
    static var sample: Self {
        .init(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
    }
}
