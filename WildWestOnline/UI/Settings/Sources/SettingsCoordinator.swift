//
//  SettingsCoordinator.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 10/09/2024.
//

import SwiftUI
import Redux
import AppCore
import NavigationCore

struct SettingsCoordinator {
    let store: Store<AppState, Any>

    func startView() -> AnyView {
        SettingsView {
            store.projection(using: SettingsViewConnector())
        }
        .eraseToAnyView()
    }

    func view(for destination: SettingsDestination) -> AnyView {
        let content = switch destination {
        case .figures:
            FiguresView {
                store.projection(using: FiguresViewConnector())
            }
            .eraseToAnyView()
        }

        return content.eraseToAnyView()
    }

}

struct SettingsCoordinatorViewConnector: Connector {
    func deriveState(_ state: AppState) -> NavigationStackState<SettingsDestination>? {
        state.navigation.settings
    }

    func embedAction(_ action: NavigationAction<SettingsDestination>) -> Any {
        action
    }
}
