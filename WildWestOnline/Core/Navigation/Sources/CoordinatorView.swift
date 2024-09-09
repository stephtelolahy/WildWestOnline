// swiftlint:disable type_contents_order
//
//  CoordinatorView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 08/09/2024.
//

import Redux
import SwiftUI

/// `CoordinatorView` is a SwiftUI view that will connect the `NavigationState` with ``NavigationStack``
public struct CoordinatorView: View {
    @StateObject private var store: Store<NavigationState, Action>
    private let viewFactory: ViewFactory

    public init(
        viewFactory: ViewFactory,
        store: @escaping () -> Store<NavigationState, Action>
    ) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
        self.viewFactory = viewFactory
    }

    public var body: some View {
        NavigationStack(path: pathBinding) {
            viewFactory.build(page: store.state.root)
                .navigationDestination(for: Page.self) { page in
                    viewFactory.build(page: page)
                }
                .sheet(item: sheetBinding) { page in
                    viewFactory.build(page: page)
                }
        }
    }

    private var pathBinding: Binding<[Page]> {
        .init(
            get: { store.state.path },
            set: { _ in }
        )
    }

    private var sheetBinding: Binding<Page?> {
        .init(
            get: { store.state.sheet },
            set: { _ in }
        )
    }
}

public protocol ViewFactory {
    func build(page: Page) -> AnyView
}

public extension CoordinatorView {
    struct Action {}
}
