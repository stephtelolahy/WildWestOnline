//
//  NavigationStackView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//

import SwiftUI
import Redux

public struct NavigationStackView<T: Destination, RootView: View, DestinationView: View>: View {
    @StateObject private var store: Store<NavigationStackState<T>, NavigationStackAction<T>, Void>
    private let root: () -> RootView
    private let destination: (T) -> DestinationView

    public init(
        store: @escaping () -> Store<NavigationStackState<T>, NavigationStackAction<T>, Void>,
        @ViewBuilder root: @escaping () -> RootView,
        @ViewBuilder destination: @escaping (T) -> DestinationView
    ) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
        self.root = root
        self.destination = destination
    }

    public var body: some View {
        NavigationStack(
            path: Binding<[T]>(
                get: { store.state.path },
                set: { _ in
                    fatalError("unimpelmented")
//                    await store.dispatch(.setPath($0))
                }
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
