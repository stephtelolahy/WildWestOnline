//
//  ActionPutTopDeckToDiscard.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

struct ActionPutTopDeckToDiscard: GameActionReducer {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        let card = try state.popDeck()
        state.discard.push(card)
        return state
    }
}
