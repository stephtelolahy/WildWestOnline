//
//  ViewCoordinator.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//

import SwiftUI

public protocol ViewCoordinator {
    associatedtype NavigationDestination: Identifiable
    associatedtype ViewContent
    associatedtype NavigationContent

    @ViewBuilder func start() -> ViewContent
    @ViewBuilder func view(for destination: NavigationDestination) -> NavigationContent
}
