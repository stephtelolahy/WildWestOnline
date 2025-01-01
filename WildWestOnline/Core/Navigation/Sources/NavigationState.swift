//
//  NavigationState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//
public struct NavigationState: Equatable, Codable {
    public var main: NavigationStackState<MainDestination>
    public var settings: NavigationStackState<SettingsDestination>

    public init(
        main: NavigationStackState<MainDestination> = .init(path: []),
        settings: NavigationStackState<SettingsDestination> = .init(path: [])
    ) {
        self.main = main
        self.settings = settings
    }
}

public enum MainDestination: String, Destination {
    case home
    case game
    case settings

    public var id: String {
        self.rawValue
    }
}

public enum SettingsDestination: String, Destination {
    case figures

    public var id: String {
        self.rawValue
    }
}
