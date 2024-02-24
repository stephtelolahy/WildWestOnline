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

    public var game: GameState?
    public var showingSettings = false

    public init(
        game: GameState? = nil
    ) {
        self.game = game
    }
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state.game = state.game.flatMap { GameState.reducer($0, action) }
        return state
    }
}
