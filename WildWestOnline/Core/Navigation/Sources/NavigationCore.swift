//
//  NavigationCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux

public enum Navigation {
    public struct State: Equatable, Codable, Sendable {
        public var mainStack: NavigationStack<MainDestination>.State
        public var settingsStack: NavigationStack<SettingsDestination>.State

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

        public init(
            mainStack: NavigationStack<MainDestination>.State = .init(path: []),
            settingsStack: NavigationStack<SettingsDestination>.State = .init(path: [])
        ) {
            self.mainStack = mainStack
            self.settingsStack = settingsStack
        }
    }

    public static func reducer(
        _ state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) throws -> Effect {
        .group([
            try NavigationStack.reducer(&state.mainStack, action: action, dependencies: ()),
            try NavigationStack.reducer(&state.settingsStack, action: action, dependencies: ())
        ])
    }
}
