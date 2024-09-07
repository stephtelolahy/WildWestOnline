//
//  SettingsCoordinatorView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import AppCore
import Redux
import SwiftUI

enum SettingsPage: Hashable {
    case main
    case figures
}

public class SettingsCoordinator: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    private let store: Store<AppState, Any>

    public init(store: Store<AppState, Any>) {
        self.store = store
    }

    func push(page: SettingsPage) {
        path.append(page)
    }

    func pop() {
        path.removeLast()
    }

    @ViewBuilder
    func build(page: SettingsPage) -> some View {
        switch page {
        case .main:
            SettingsView {
                self.store.projection(SettingsView.deriveState, SettingsView.embedAction)
            }

        case .figures:
            FiguresView()
        }
    }
}

public struct SettingsCoordinatorView: View {
    @StateObject private var coordinator: SettingsCoordinator

    public init(coordinator: @escaping () -> SettingsCoordinator) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _coordinator = StateObject(wrappedValue: coordinator())
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .main)
                .navigationDestination(for: SettingsPage.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}
