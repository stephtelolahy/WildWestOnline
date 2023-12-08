//
//  ActionDiscardInPlay.swift
//  
//
//  Created by Hugues Telolahy on 02/09/2023.
//

struct ActionDiscardInPlay: GameActionReducer {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \GameState.players[player]]?.inPlay.remove(card)
        state.discard.push(card)
        return state
    }
}
