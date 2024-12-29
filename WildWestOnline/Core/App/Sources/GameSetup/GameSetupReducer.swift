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
        guard let action = action as? GameSetupAction else {
            return state
        }

        var state = state
        switch action {
        case .setGame(let game):
            state.game = game

        case .unsetGame:
            state.game = nil

        case .startGame:
            break

        case .quitGame:
            break
        }

        return state
    }
}
