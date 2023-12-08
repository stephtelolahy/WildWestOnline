//
//  ActionSetGameOver.swift
//  
//
//  Created by Hugues Telolahy on 02/07/2023.
//

struct ActionSetGameOver: GameActionReducer {
    let winner: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.winner = winner
        return state
    }
}
