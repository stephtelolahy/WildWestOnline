//
//  NavigationCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux

public struct NavigationState: Equatable, Codable, Sendable {
    public var mainStack: NavigationStackState<MainDestination>
    public var settingsStack: NavigationStackState<SettingsDestination>

    public init(
        mainStack: NavigationStackState<MainDestination> = .init(path: []),
        settingsStack: NavigationStackState<SettingsDestination> = .init(path: [])
    ) {
        self.mainStack = mainStack
        self.settingsStack = settingsStack
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
        navigationStackReducer(state: &state.mainStack, action: action, dependencies: ()),
        navigationStackReducer(state: &state.settingsStack, action: action, dependencies: ())
    ])
}
