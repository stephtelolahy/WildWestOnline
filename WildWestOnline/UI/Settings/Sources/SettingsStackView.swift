//
//  SettingsStackView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux
import SwiftUI
import AppCore
import NavigationCore

public struct SettingsStackView: View {
    private let store: Store<AppState>

    public init(store: Store<AppState>) {
        self.store = store
    }

    public var body: some View {
        NavigationStackView<SettingsDestination, SettingsRootView, AnyView>(
            store: {
                store.projection(SettingsStackView.presenter)
            },
            root: {
                SettingsRootView {
                    store.projection(SettingsRootView.presenter)
                }
            },
            destination: { destination in
                let content = switch destination {
                case .figures:
                    SettingsFiguresView {
                        store.projection(SettingsFiguresView.presenter)
                    }
                }

                content.eraseToAnyView()
            }
        )
    }
}

private extension SettingsStackView {
    static let presenter: Presenter<AppState, NavigationStackState<SettingsDestination>> = { state in
        state.navigation.settings
    }
}
