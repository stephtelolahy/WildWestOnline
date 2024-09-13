//
//  NavigationState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//
import Redux

public struct NavigationState: Equatable, Codable {
    public var root: NavigationStackState<RootDestination>
    public var settings: NavigationStackState<SettingsDestination>

    public init(
        root: NavigationStackState<RootDestination> = .init(path: []),
        settings: NavigationStackState<SettingsDestination> = .init(path: [])
    ) {
        self.root = root
        self.settings = settings
    }
}

public enum RootDestination: String, Destination {
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

public extension NavigationState {
    static let reducer: Reducer<Self, Any> = { state, action in
        var state = state

        if let action = action as? NavigationAction<RootDestination> {
            state.root.reducer(action: action)
        }

        if let action = action as? NavigationAction<SettingsDestination> {
            state.settings.reducer(action: action)
        }

        return state
    }
}
