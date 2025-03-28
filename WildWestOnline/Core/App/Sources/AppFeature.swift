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
        public var game: GameState?

        public init(
            navigation: NavigationFeature.State,
            settings: SettingsFeature.State,
            inventory: Inventory,
            game: GameState? = nil
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
        .group([
            try NavigationFeature.reduce(into: &state.navigation, action: action, dependencies: ()),
            try SettingsFeature.reduce(into: &state.settings, action: action, dependencies: dependencies.settings),
            try setupGameReducer(state: &state, action: action, dependencies: ()),
            try reduceCurrentGame(into: &state, action: action, dependencies: ()),
            try loggerReducer(state: &state, action: action, dependencies: ())
        ])
    }

    private static func reduceCurrentGame(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) throws -> Effect {
        guard state.game != nil else {
            return .none
        }

        // swiftlint:disable force_unwrapping
        return .group([
            try gameReducer(state: &state.game!, action: action, dependencies: ()),
            try updateGameReducer(state: &state.game!, action: action, dependencies: ()),
            try playAIMoveReducer(state: &state.game!, action: action, dependencies: ())
        ])
    }
}
