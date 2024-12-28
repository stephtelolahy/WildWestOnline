//
//  AppState.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import NavigationCore
import SettingsCore
import Bang

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
