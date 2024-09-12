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
    static let rootReducer: Reducer<Self, NavigationAction<RootDestination>> = { state, action in
        var state = state
        switch action {
        case .push(let page):
            state.root.path.append(page)

        case .pop:
            state.root.path.removeLast()

        case .setPath(let path):
            state.root.path = path

        case .present(let page):
            state.root.sheet = page

        case .dismiss:
            state.root.sheet = nil
        }

        return state
    }

    static let settingsReducer: Reducer<Self, NavigationAction<SettingsDestination>> = { state, action in
        var state = state
        switch action {
        case .push(let page):
            state.settings.path.append(page)

        case .pop:
            state.settings.path.removeLast()

        case .setPath(let path):
            state.settings.path = path

        default:
            fatalError()
        }

        return state
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
