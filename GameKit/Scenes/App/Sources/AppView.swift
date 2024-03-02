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
                    store.projection {
                        SplashView.State.from(globalState: $0)
                    }
                }

            case .home:
                HomeView {
                    store.projection {
                        HomeView.State.from(globalState: $0)
                    }
                }

            case .game:
                GamePlayView {
                    store.projection {
                        GamePlayView.State.from(globalState: $0)
                    }
                }

            default:
                EmptyView()
            }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { store.state.alert == .settings },
            set: { _ in }
        ), onDismiss: {
        }, content: {
            SettingsView {
                store.projection {
                    SettingsView.State.from(globalState: $0)
                }
            }
        })
        .foregroundColor(.primary)
    }
}

#Preview {
    AppView {
        Store<AppState>(initial: previewState)
    }
}

private var previewState: AppState {
    .init(screens: [.splash], settings: .init())
}
