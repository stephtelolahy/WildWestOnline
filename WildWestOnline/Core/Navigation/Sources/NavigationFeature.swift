//
//  NavigationFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux

public enum NavigationFeature {
    public struct State: Equatable, Codable, Sendable {
        public var mainStack: NavStackFeature<MainDestination>.State
        public var settingsStack: NavStackFeature<SettingsDestination>.State

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
            mainStack: NavStackFeature<MainDestination>.State = .init(path: []),
            settingsStack: NavStackFeature<SettingsDestination>.State = .init(path: [])
        ) {
            self.mainStack = mainStack
            self.settingsStack = settingsStack
        }
    }

    public static func reduce(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) throws -> Effect {
        .group([
            try NavStackFeature.reduce(into: &state.mainStack, action: action, dependencies: ()),
            try NavStackFeature.reduce(into: &state.settingsStack, action: action, dependencies: ())
        ])
    }
}
