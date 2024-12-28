//
//  GameSetupReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux
import GameCore
import SettingsCore

public struct GameSetupReducer {
    public init() {}

    public func reduce(_ state: AppState, _ action: Action) throws -> AppState {
        var state = state

        switch action {
        case GameSetupAction.setGame(let game):
            state.game = game

        case GameSetupAction.unsetGame:
            state.game = nil

        default:
            break
        }

        return state
    }
}
