// swiftlint:disable type_contents_order
//
//  CoordinatorView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 08/09/2024.
//

import SwiftUI

/// `CoordinatorView` is a SwiftUI view that will connect the navigation state with ``NavigationStack``
public struct CoordinatorView: View {
    @Binding private var path: [Page]
    @Binding private var sheet: Page?
    private let root: Page
    private let viewFactory: ViewFactory

    public init(
        root: Page,
        pathBinding: Binding<[Page]>,
        sheetBinding: Binding<Page?>,
        viewFactory: ViewFactory
    ) {
        _path = pathBinding
        _sheet = sheetBinding
        self.viewFactory = viewFactory
        self.root = root
    }

    public var body: some View {
        NavigationStack(path: $path) {
            viewFactory.build(page: root)
                .navigationDestination(for: Page.self) { page in
                    viewFactory.build(page: page)
                }
                .sheet(item: $sheet) { page in
                    viewFactory.build(page: page)
                }
        }
    }
}

public protocol ViewFactory {
    func build(page: Page) -> AnyView
}
