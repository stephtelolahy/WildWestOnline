//
//  NavigationCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux

public enum Navigation {
    public struct State: Equatable, Codable, Sendable {
        public var mainStack: NavStack<MainDestination>.State
        public var settingsStack: NavStack<SettingsDestination>.State

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
            mainStack: NavStack<MainDestination>.State = .init(path: []),
            settingsStack: NavStack<SettingsDestination>.State = .init(path: [])
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
            try NavStack.reducer(&state.mainStack, action: action, dependencies: ()),
            try NavStack.reducer(&state.settingsStack, action: action, dependencies: ())
        ])
    }
}
