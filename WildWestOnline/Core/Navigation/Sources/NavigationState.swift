//
//  NavigationState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//
import Redux

public struct NavigationState: Equatable, Codable {
    public var root: RootNavigationState
    public var settings: SettingsNavigationState

    public init(
        root: RootNavigationState = .init(path: []),
        settings: SettingsNavigationState = .init(path: [])
    ) {
        self.root = root
        self.settings = settings
    }
}
