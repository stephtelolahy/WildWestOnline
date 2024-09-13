//
//  SettingsAssembly.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//
import SwiftUI
import AppCore
import NavigationCore
import Redux

public enum SettingsAssembly {
    public static func buildSettingsNavigationView(_ store: Store<AppState, Any>) -> some View {
        NavigationStackView<SettingsDestination, SettingsView, AnyView>(
            store: {
                store.projection(using: SettingsNavigationConnector())
            },
            root: {
                SettingsView {
                    store.projection(using: SettingsViewConnector())
                }
            },
            destination: { destination in
                let content = switch destination {
                case .figures:
                    FiguresView {
                        store.projection(using: FiguresViewConnector())
                    }
                }

                return content.eraseToAnyView()
            }
        )
    }
}

private struct SettingsNavigationConnector: Connector {
    func deriveState(_ state: AppState) -> NavigationStackState<SettingsDestination>? {
        state.navigation.settings
    }

    func embedAction(_ action: NavigationAction<SettingsDestination>) -> Any {
        action
    }
}

