//
//  AppCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

import Redux
import NavigationCore
import SettingsCore
import GameCore

public enum AppFeature {
    /// Global app state
    /// Organize State Structure Based on Data Types, Not Components
    /// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
    public struct State: Codable, Equatable, Sendable {
        public var navigation: NavigationFeature.State
        public var settings: SettingsFeature.State
        public let inventory: Inventory
        public var game: GameFeature.State?

        public init(
            navigation: NavigationFeature.State,
            settings: SettingsFeature.State,
            inventory: Inventory,
            game: GameFeature.State? = nil
        ) {
            self.navigation = navigation
            self.settings = settings
            self.inventory = inventory
            self.game = game
        }
    }

    public struct Dependencies {
        let settings: SettingsFeature.Dependencies

        public init(settings: SettingsFeature.Dependencies) {
            self.settings = settings
        }
    }

    public static func reduce(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Dependencies
    ) throws -> Effect {
        let activeGameEffet: Effect = if state.game != nil {
            try GameFeature.reduce(into: &state.game!, action: action, dependencies: ())
        } else {
            .none
        }

        return .group([
            try NavigationFeature.reduce(into: &state.navigation, action: action, dependencies: ()),
            try SettingsFeature.reduce(into: &state.settings, action: action, dependencies: dependencies.settings),
            try GameSessionFeature.reduce(into: &state, action: action, dependencies: ()),
            activeGameEffet,
            try loggerReducer(state: &state, action: action, dependencies: ()),
        ])
    }
}
