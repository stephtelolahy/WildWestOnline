//
//  ActionEndTurn.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 25/05/2024.
//

struct ActionEndTurn: GameActionReducer {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.turn = nil
        return state
    }
}
