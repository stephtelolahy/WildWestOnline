//
//  GameSetupReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux
import GameCore
import SettingsCore

extension AppState {
    static let gameSetupReducer: Reducer<Self> = { state, action in
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
