//
//  AppState.swift
//
//
//  Created by Hugues Telolahy on 12/07/2023.
//

import Game
import GameUI
import HomeUI
import Inventory
import Navigation
import Redux
import SettingsUI
import SplashUI

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

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state = activeGameReducer(state, action)
        state.game = state.game.flatMap { GameState.reducer($0, action) }
        state.screens = NavState.reducer(state.screens, action)
        state.settings = SettingsState.reducer(state.settings, action)
        return state
    }
}

private extension AppState {
    static let activeGameReducer: Reducer<AppState> = { state, action in
        var state = state

        if case let NavAction.showScreen(screen, _) = action,
           screen == .game {
            state.game = state.createGame()
        }

        if case NavAction.dismiss = action,
           state.screens.last == .game {
            state.game = nil
        }

        return state
    }

    func createGame() -> GameState {
        var game = Inventory.createGame(playersCount: settings.playersCount)
        var manualPlayer: String?
        if !settings.simulation {
            manualPlayer = game.playOrder[0]
        }
        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }
        return game
    }
}

// MARK: - Extract local states

public extension GameState {
    static func from(globalState: AppState) -> Self? {
        globalState.game
    }
}

extension HomeState {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}

extension SplashState {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}

public extension SettingsState {
    static func from(globalState: AppState) -> Self? {
        globalState.settings
    }
}
