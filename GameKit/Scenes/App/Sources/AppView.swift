//
//  MainView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

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
                fatalError()
            }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { store.state.screens.last == .settings },
            set: { _ in }
        ), onDismiss: {
            store.dispatch(AppAction.close)
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