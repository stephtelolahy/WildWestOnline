//
//  ActionPutBackHand.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 19/12/2023.
//

struct ActionPutBackHand: GameActionReducer {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state.deck.insert(card, at: 0)
        return state
    }
}
