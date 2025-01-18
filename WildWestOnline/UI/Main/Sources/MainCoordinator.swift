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
    @EnvironmentObject private var store: Store<AppState, AppDependencies>

    public init() {}

    public var body: some View {
        NavigationStackView(
            store: {
                store.projection(MainCoordinator.presenter)
            },
            rootView: {
                SplashContainerView()
            },
            destinationView: { destination in
                switch destination {
                case .home: HomeContainerView().eraseToAnyView()
                case .game: GameContainerView().eraseToAnyView()
                case .settings: SettingsCoordinator().eraseToAnyView()
                }
            }
        )
    }
}

#Preview {
    MainCoordinator()
        .environmentObject(
            Store<AppState, AppDependencies>.init(
                initialState: .mockedData,
                dependencies: .mockedData
            )
        )
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

private extension AppDependencies {
    static var mockedData: Self {
        .init(
            settings: .init(
                savePlayersCount: { _ in },
                saveActionDelayMilliSeconds: { _ in },
                saveSimulationEnabled: { _ in },
                savePreferredFigure: { _ in }
            )
        )
    }
}

extension MainCoordinator {
    static let presenter: Presenter<AppState, NavigationStackState<MainDestination>> = { state in
        state.navigation.main
    }
}
