//
//  AppState.swift
//
//
//  Created by Hugues Telolahy on 12/07/2023.
//

import GameCore
import GamePlay
import Home
import Inventory
import Redux
import Settings
import Splash

/// Global app state
/// Organize State Structure Based on Data Types, Not Components
/// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
public struct AppState: Codable, Equatable {
    public enum Screen: Codable, Equatable {
        case game
    }

    public var screen: Screen
    public var game: GameState?
    public var showingSettings = false

    public init(
        screen: Screen,
        game: GameState? = nil
    ) {
        self.screen = screen
        self.game = game
    }
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state = screenReducer(state, action)
        state.game = state.game.flatMap { GameState.reducer($0, action) }
        return state
    }
}

private extension AppState {
    static let screenReducer: Reducer<AppState> = { state, action in
        var state = state

        if case GamePlayAction.quit = action {
            state.game = nil
        }

        return state
    }
}

// MARK: - Extract local states

extension GameState {
    static func from(globalState: AppState) -> Self? {
        globalState.game
    }
}
