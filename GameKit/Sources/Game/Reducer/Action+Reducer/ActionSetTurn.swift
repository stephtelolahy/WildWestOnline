//
//  ActionSetTurn.swift
//  
//
//  Created by Hugues Telolahy on 01/05/2023.
//

struct ActionSetTurn: GameReducerProtocol {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.turn = player
        state.playCounter = [:]
        return state
    }
}
