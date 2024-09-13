//
//  CoordinatorView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//
// swiftlint:disable type_contents_order

import SwiftUI
import Redux

public struct CoordinatorView<T: Destination>: View {
    @StateObject private var store: Store<NavigationStackState<T>, NavigationAction<T>>
    private let coordinator: any Coordinator<T>

    public init(
        store: @escaping () -> Store<NavigationStackState<T>, NavigationAction<T>>,
        coordinator: any Coordinator<T>
    ) {
        _store = StateObject(wrappedValue: store())
        self.coordinator = coordinator
    }

    public var body: some View {
        NavigationStack(path: pathBinding) {
            coordinator.startView()
                .navigationDestination(for: T.self) { destination in
                    coordinator.view(for: destination)
                }
                .sheet(item: sheetBinding) { destination in
                    coordinator.view(for: destination)
                }
        }
    }

    private var pathBinding: Binding<[T]> {
        .init(
            get: { store.state.path },
            set: { store.dispatch(.setPath($0)) }
        )
    }

    private var sheetBinding: Binding<T?> {
        .init(
            get: { store.state.sheet },
            set: { _ in }
        )
    }
}

public protocol Coordinator<T> {
    associatedtype T: Destination

    func startView() -> AnyView
    func view(for destination: T) -> AnyView
}

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
