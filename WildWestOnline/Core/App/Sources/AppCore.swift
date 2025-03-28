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
    public var navigation: Navigation.State
    public var settings: Settings.State
    public let inventory: Inventory
    public var game: GameState?

    public init(
        navigation: Navigation.State,
        settings: Settings.State,
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
    let settings: Settings.Dependencies

    public init(settings: Settings.Dependencies) {
        self.settings = settings
    }
}

public func appReducer(
    state: inout AppState,
    action: ActionProtocol,
    dependencies: AppDependencies
) throws -> Effect {
    .group([
        try Navigation.reducer(&state.navigation, action: action, dependencies: ()),
        try Settings.reducer(&state.settings, action: action, dependencies: dependencies.settings),
        try setupGameReducer(state: &state, action: action, dependencies: ()),
        try currentGameReducer(state: &state, action: action, dependencies: ()),
        try loggerReducer(state: &state, action: action, dependencies: ())
    ])
}

private func currentGameReducer(state: inout AppState, action: ActionProtocol, dependencies: Void) throws -> Effect {
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
