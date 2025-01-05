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
public struct AppState: Codable, Equatable, Sendable {
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

public struct AppDependencies {
    let settings: SettingsDependencies

    public init(settings: SettingsDependencies) {
        self.settings = settings
    }
}

public func appReducer(
    state: inout AppState,
    action: Action,
    dependencies: AppDependencies
) throws -> Effect {
    .group([
        try navigationReducer(state: &state.navigation, action: action, dependencies: ()),
        try settingsReducer(state: &state.settings, action: action, dependencies: dependencies.settings),
        try setupGameReducer(state: &state, action: action, dependencies: ()),
        try currentGameReducer(state: &state, action: action, dependencies: ())
    ])
}

private func currentGameReducer(state: inout AppState, action: Action, dependencies: Void) throws -> Effect {
    guard state.game != nil else {
        return .none
    }

    // swiftlint:disable:next force_unwrapping
    return try gameReducer(state: &state.game!, action: action, dependencies: ())
}
