//
//  ActionPutBack.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

struct ActionPutBack: GameActionReducer {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.deck.insert(contentsOf: state.arena, at: 0)
        state.arena = []
        return state
    }
}
