//
//  MainView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

import SwiftUI
import NavigationCore
import Redux
import AppCore
import SplashUI
import SettingsUI
import HomeUI
import GameUI

struct MainView: View {
    let store: Store<AppState>

    var body: some View {
        NavigationStackView(
            store: {
                store.projection(MainView.presenter)
            },
            root: {
                SplashView {
                    store.projection(SplashView.presenter)
                }
            },
            destination:  { destination in
                let content = switch destination {
                case .home:
                    HomeView {
                        store.projection(HomeView.presenter)
                    }
                    .eraseToAnyView()

                case .game:
                    GameView {
                        store.projection(GameView.presenter)
                    }
                    .eraseToAnyView()
                    
                case .settings:
                    SettingsStackView(store: store)
                        .eraseToAnyView()
                }

                content.eraseToAnyView()
            }
        )
    }
}

#Preview {
    MainView(store: .init(initial: .mockedData))
}

private extension AppState {
    static var mockedData: Self {
        .init(
            navigation: .init(),
            settings: .makeBuilder().build(),
            inventory: .makeBuilder().build()
        )
    }
}

private extension MainView {
    static let presenter: Presenter<AppState, NavigationStackState<RootDestination>> = { state in
        state.navigation.root
    }
}
