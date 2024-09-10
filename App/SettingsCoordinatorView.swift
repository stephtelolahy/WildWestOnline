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
    @StateObject private var store: Store<SettingsNavigationState, SettingsNavigationAction>
    private let coordinator: Coordinator

    init(
        store: @escaping () -> Store<SettingsNavigationState, SettingsNavigationAction>,
        coordinator: Coordinator
    ) {
        _store = StateObject(wrappedValue: store())
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: pathBinding) {
            coordinator.start()
                .navigationDestination(for: SettingsNavigationState.Destination.self) { destination in
                    coordinator.view(for: destination)
                }
                .sheet(item: sheetBinding) { destination in
                    coordinator.view(for: destination)
                }
        }
    }

    private var pathBinding: Binding<[SettingsNavigationState.Destination]> {
        .init(
            get: { store.state.path },
            set: { store.dispatch(.setPath($0)) }
        )
    }

    private var sheetBinding: Binding<SettingsNavigationState.Destination?> {
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
                store.projection(SettingsView.deriveState, SettingsView.embedAction)
            }
        }

        @MainActor func view(for destination: SettingsNavigationState.Destination) -> some View {
            switch destination {
            case .figures:
                FiguresView {
                    store.projection(FiguresView.deriveState, FiguresView.embedAction)
                }
            }
        }
    }
}
