//
//  ActionStartTurn.swift
//  
//
//  Created by Hugues Telolahy on 01/05/2023.
//

struct ActionStartTurn: GameActionReducer {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.turn = player
        state.playedThisTurn = [:]
        return state
    }
}