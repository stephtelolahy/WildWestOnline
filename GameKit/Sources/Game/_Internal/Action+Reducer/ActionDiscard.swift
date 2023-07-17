//
//  ActionDiscard.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct ActionDiscard: GameReducerProtocol {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        try state[keyPath: \GameState.players[player]]?.removeCard(card)
        state.discard.push(card)
        return state
    }
}
