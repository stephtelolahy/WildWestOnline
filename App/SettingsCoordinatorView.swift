//
//  SettingsCoordinatorView.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 10/09/2024.
//

import SwiftUI
import Redux
import AppCore
import NavigationCore
import SettingsUI

struct SettingsCoordinatorView: View {
    @StateObject private var store: Store<NavigationStackState<SettingsDestination>, NavigationAction<SettingsDestination>>
    private let coordinator: Coordinator

    init(
        store: @escaping () -> Store<NavigationStackState<SettingsDestination>, NavigationAction<SettingsDestination>>,
        coordinator: Coordinator
    ) {
        _store = StateObject(wrappedValue: store())
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: pathBinding) {
            coordinator.start()
                .navigationDestination(for: SettingsDestination.self) { destination in
                    coordinator.view(for: destination)
                }
                .sheet(item: sheetBinding) { destination in
                    coordinator.view(for: destination)
                }
        }
    }

    private var pathBinding: Binding<[SettingsDestination]> {
        .init(
            get: { store.state.path },
            set: { store.dispatch(.setPath($0)) }
        )
    }

    private var sheetBinding: Binding<SettingsDestination?> {
        .init(
            get: { store.state.sheet },
            set: { _ in }
        )
    }
}

extension SettingsCoordinatorView {
    struct Coordinator: @preconcurrency ViewCoordinator {
        let store: Store<AppState, Any>

        @MainActor func start() -> some View {
            SettingsView {
                store.projection(using: SettingsViewConnector())
            }
        }

        @MainActor func view(for destination: SettingsDestination) -> some View {
            switch destination {
            case .figures:
                FiguresView {
                    store.projection(using: FiguresViewConnector())
                }
            }
        }
    }
}

struct SettingsNavViewConnector: Connector {
    func deriveState(_ state: AppState) -> NavigationStackState<SettingsDestination>? {
        state.navigation.settings
    }

    func embedAction(_ action: NavigationAction<SettingsDestination>) -> Any {
        action
    }
}
