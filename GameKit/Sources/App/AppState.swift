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
import Redux
import SettingsUI
import SplashUI

/// Global app state
/// Organize State Structure Based on Data Types, Not Components
/// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
public struct AppState: Codable, Equatable {
    public var screen: Screen
    public var settings: SettingsState
    public var game: GameState?
    public var showingSettings = false

    public init(
        screen: Screen,
        settings: SettingsState,
        game: GameState? = nil
    ) {
        self.screen = screen
        self.settings = settings
        self.game = game
    }
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state = screenReducer(state, action)
        state.settings = SettingsState.reducer(state.settings, action)
        state.game = state.game.flatMap { GameState.reducer($0, action) }
        return state
    }
}

private extension AppState {
    static let screenReducer: Reducer<AppState> = { state, action in
        var state = state

        if case SplashAction.finish = action {
            state.screen = .home
        }

        if case HomeAction.play = action {
            state.game = state.createGame()
            state.screen = .game
        }

        if case HomeAction.openSettings = action {
            state.showingSettings = true
        }

        if case SettingsAction.close = action {
            state.showingSettings = false
        }

        if case GamePlayAction.quit = action {
            state.game = nil
            state.screen = .home
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
