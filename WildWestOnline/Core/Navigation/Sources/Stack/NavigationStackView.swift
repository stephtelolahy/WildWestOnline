//
//  NavigationStackView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//
// swiftlint:disable type_contents_order

import Redux
import SwiftUI

public struct NavigationStackView<T: Destination, RootView: View, DestinationView: View>: View {
    @StateObject private var store: Store<NavigationStackState<T>>
    private let root: () -> RootView
    private let destination: (T) -> DestinationView

    public init(
        store: @escaping () -> Store<NavigationStackState<T>>,
        @ViewBuilder root: @escaping () -> RootView,
        @ViewBuilder destination: @escaping (T) -> DestinationView
    ) {
        _store = StateObject(wrappedValue: store())
        self.root = root
        self.destination = destination
    }

    public var body: some View {
        NavigationStack(
            path: Binding<[T]>(
                get: { store.state.path },
                set: { store.dispatch(NavigationStackAction<T>.setPath($0)) }
            )
        ) {
            root()
                .navigationDestination(for: T.self) {
                    destination($0)
                }
                .sheet(
                    item: Binding<T?>(
                        get: { store.state.sheet },
                        set: { _ in }
                    )
                ) {
                    destination($0)
                }
        }
    }
}

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}