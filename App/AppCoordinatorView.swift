//
//  AppCoordinatorView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//
import SwiftUI
import NavigationCore

/// `CoordinatorView` is a SwiftUI view that will be set as the entry point of the application.
/// This view will connect the navigation state with ``NavigationStack``
struct AppCoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator

    init(coordinator: @escaping () -> AppCoordinator) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _coordinator = StateObject(wrappedValue: coordinator())
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            EmptyView()
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { page in
                    coordinator.build(page: page)
                }
        }
    }
}
