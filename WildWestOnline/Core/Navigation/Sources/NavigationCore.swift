//
//  NavigationCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux

public struct NavigationState: Equatable, Codable, Sendable {
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

public func navigationReducer(
    state: inout NavigationState,
    action: Action,
    dependencies: Void
) throws -> Effect {
    .group([
        navigationStackReducer(state: &state.main, action: action, dependencies: ()),
        navigationStackReducer(state: &state.settings, action: action, dependencies: ())
    ])
}
