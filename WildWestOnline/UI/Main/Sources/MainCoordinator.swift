//
//  MainCoordinator.swift
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

public struct MainCoordinator: View {
    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        NavigationStackView(
            store: {
                store.projection(MainCoordinator.presenter)
            },
            root: {
                SplashViewBuilder()
            },
            destination: { destination in
                switch destination {
                case .home: HomeViewBuilder().eraseToAnyView()
                case .game: GameViewBuilder().eraseToAnyView()
                case .settings: SettingsCoordinator().eraseToAnyView()
                }
            }
        )
    }
}

#Preview {
    MainCoordinator()
        .environmentObject(Store<AppState>.init(initial: .mockedData))
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

extension MainCoordinator {
    static let presenter: Presenter<AppState, NavigationStackState<MainDestination>> = { state in
        state.navigation.main
    }
}
