//
//  ActionDrawDiscard.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

struct ActionDrawDiscard: GameActionReducer {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        let card = try state.popDiscard()
        state[keyPath: \GameState.players[player]]?.hand.append(card)
        return state
    }
}