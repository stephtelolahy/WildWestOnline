//
//  ActionPutBack.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

struct ActionPutBack: GameActionReducer {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        if let arena = state.arena {
            state.deck.cards.insert(contentsOf: arena.cards, at: 0)
            state.arena = nil
        }
        return state
    }
}
