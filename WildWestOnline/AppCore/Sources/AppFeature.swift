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
        public var navigation: AppNavigationFeature.State
        public var settings: SettingsFeature.State
        public let inventory: Inventory
        public var game: GameFeature.State?

        public init(
            navigation: AppNavigationFeature.State,
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
    ) -> Effect {
        let activeGameEffet: Effect = if state.game != nil {
            GameFeature.reduce(into: &state.game!, action: action, dependencies: ())
        } else {
            .none
        }

        return .group([
            activeGameEffet,
            GameSessionFeature.reduce(into: &state, action: action, dependencies: ()),
            SettingsFeature.reduce(into: &state.settings, action: action, dependencies: dependencies.settings),
            AppNavigationFeature.reduce(into: &state.navigation, action: action, dependencies: ()),
        ])
    }
}
