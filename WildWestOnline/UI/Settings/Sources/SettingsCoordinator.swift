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
    @EnvironmentObject private var store: Store<AppState, AppDependencies>

    public init() {}

    public var body: some View {
        NavigationStackView<SettingsDestination, SettingsRootContainerView, AnyView>(
            store: {
                store.projection(Self.presenter)
            },
            rootView: {
                SettingsRootContainerView()
            },
            destinationView: { destination in
                switch destination {
                case .figures: SettingsFiguresContainerView().eraseToAnyView()
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
