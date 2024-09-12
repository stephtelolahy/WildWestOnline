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
    private let startView: () -> AnyView
    private let destinationView: (T) -> AnyView

    public init(
        store: @escaping () -> Store<NavigationStackState<T>, NavigationAction<T>>,
        startView: @escaping () -> AnyView,
        destinationView: @escaping (T) -> AnyView
    ) {
        _store = StateObject(wrappedValue: store())
        self.startView = startView
        self.destinationView = destinationView
    }

    public var body: some View {
        NavigationStack(path: pathBinding) {
            startView()
                .navigationDestination(for: T.self) { destination in
                    destinationView(destination)
                }
                .sheet(item: sheetBinding) { destination in
                    destinationView(destination)
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

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
