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

/// Global app state
/// Organize State Structure Based on Data Types, Not Components
/// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
public struct AppState: Codable, Equatable {
    public var navigation: NavigationState
    public var settings: SettingsState
    public let inventory: Inventory
    public var game: GameState?

    public init(
        navigation: NavigationState,
        settings: SettingsState,
        inventory: Inventory,
        game: GameState? = nil
    ) {
        self.navigation = navigation
        self.settings = settings
        self.inventory = inventory
        self.game = game
    }
}

public enum AppAction: Sendable {
    case navigation(NavigationAction)
    case settings(SettingsAction)
    case game(GameAction)
    case setup(GameSetupAction)
}

public func appReducer(
    state: inout AppState,
    action: AppAction,
    dependencies: Void
) throws -> Effect<AppAction> {
    switch action {
    case .navigation(let navigationAction):
        return try navigationReducer(state: &state.navigation, action: navigationAction, dependencies: ())

    case .settings(let settingsAction):
        return try settingsReducer(state: &state.settings, action: settingsAction, dependencies: ())

    case .game(let gameAction):
        return try gameReducer(state: &state.game, action: gameAction, dependencies: ())

    case .setup(let setupAction):
        return try gameSetupReducer(state: &state, action: setupAction, dependencies: ())
    }
}
