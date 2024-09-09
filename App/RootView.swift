//
//  RootView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//

import SwiftUI
import NavigationCore
import Redux

struct RootView: View {
    @StateObject private var store: Store<RootNavigationState, RootNavigationAction>
    private let coordinator: RootViewCoordinator

    init(
        store: @escaping () -> Store<RootNavigationState, RootNavigationAction>,
        coordinator: RootViewCoordinator
    ) {
        _store = StateObject(wrappedValue: store())
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: pathBinding) {
            coordinator.start()
                .navigationDestination(for: RootNavigationState.Destination.self) { destination in
                    coordinator.view(for: destination)
                }
                .sheet(item: sheetBinding) { destination in
                    coordinator.view(for: destination)
                }
        }
    }

    private var pathBinding: Binding<[RootNavigationState.Destination]> {
        .init(
            get: { store.state.path },
            set: { _ in }
        )
    }

    private var sheetBinding: Binding<RootNavigationState.Destination?> {
        .init(
            get: { store.state.sheet },
            set: { _ in }
        )
    }
}
