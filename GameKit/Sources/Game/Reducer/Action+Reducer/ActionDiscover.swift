//
//  ActionDiscover.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct ActionDiscover: GameActionReducer {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        let card = try state.popDeck()
        state.arena.append(card)
        return state
    }
}
