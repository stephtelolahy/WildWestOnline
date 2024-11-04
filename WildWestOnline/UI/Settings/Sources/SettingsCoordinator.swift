//
//  SettingsCoordinator.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux
import SwiftUI
import AppCore
import NavigationCore

public struct SettingsCoordinator: View {
    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        NavigationStackView<SettingsDestination, SettingsRootViewBuilder, AnyView>(
            store: {
                store.projection(Self.presenter)
            },
            root: {
                SettingsRootViewBuilder()
            },
            destination: { destination in
                switch destination {
                case .figures: SettingsFiguresViewBuilder().eraseToAnyView()
                }
            }
        )
    }
}

private extension SettingsCoordinator {
    static let presenter: Presenter<AppState, NavigationStackState<SettingsDestination>> = { state in
        state.navigation.settings
    }
}
