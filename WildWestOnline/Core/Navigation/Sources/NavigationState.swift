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

public protocol Destination: Identifiable, Equatable, Codable {}

public struct NavigationStackState<T: Destination>: Equatable, Codable {
    public var path: [T]
    public var sheet: T?

    public init(path: [T], sheet: T? = nil) {
        self.path = path
        self.sheet = sheet
    }
}

public enum NavigationAction<T: Destination> {
    case push(T)
    case pop
    case setPath([T])
    case present(T)
    case dismiss
}

public extension NavigationState {
    static let reducer: Reducer<Self, Any> = { state, action in
        var state = state
        switch action {
        case let action as NavigationAction<RootDestination>:
            state = try NavigationState.rootReducer(state, action)

        case let action as NavigationAction<SettingsDestination>:
            state = try NavigationState.settingsReducer(state, action)

        default:
            break
        }

        return state
    }
}
