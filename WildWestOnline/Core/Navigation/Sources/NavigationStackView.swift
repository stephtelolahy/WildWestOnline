//
//  NavigationStackView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//

import SwiftUI
import Redux

public struct NavigationStackView<T: Destination, RootView: View, DestinationView: View>: View {
    @StateObject private var store: Store<NavigationStackState<T>, Void>
    private let rootView: () -> RootView
    private let destinationView: (T) -> DestinationView

    public init(
        store: @escaping () -> Store<NavigationStackState<T>, Void>,
        @ViewBuilder rootView: @escaping () -> RootView,
        @ViewBuilder destinationView: @escaping (T) -> DestinationView
    ) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
        self.rootView = rootView
        self.destinationView = destinationView
    }

    public var body: some View {
        NavigationStack(
            path: Binding<[T]>(
                get: { store.state.path },
                set: { path in
                    Task {
                        await store.dispatch(NavigationStackAction<T>.setPath(path))
                    }
                }
            )
        ) {
            rootView()
                .navigationDestination(for: T.self) {
                    destinationView($0)
                }
                .sheet(
                    item: Binding<T?>(
                        get: { store.state.sheet },
                        set: { _ in }
                    )
                ) {
                    destinationView($0)
                }
        }
    }
}
