//
//  AppState.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import GameCore
import Redux
import SettingsCore

/// Global app state
/// Organize State Structure Based on Data Types, Not Components
/// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
public struct AppState: Codable, Equatable {
    public var screens: [Screen]
    public var settings: SettingsState
    public var game: GameState?

    public init(
        screens: [Screen],
        settings: SettingsState,
        game: GameState? = nil
    ) {
        self.screens = screens
        self.settings = settings
        self.game = game
    }
}

public enum Screen: Codable, Equatable {
    case splash
    case home
    case game
    case settings
}

public enum AppAction: Action {
    case navigate(Screen)
    case close
}
