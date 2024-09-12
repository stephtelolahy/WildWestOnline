//
//  ViewCoordinator.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//

import SwiftUI
import NavigationCore

public protocol ViewCoordinator {
    associatedtype T: Destination
    associatedtype RootContent
    associatedtype ViewContent

    @ViewBuilder func start() -> RootContent
    @ViewBuilder func view(for destination: T) -> ViewContent
}
