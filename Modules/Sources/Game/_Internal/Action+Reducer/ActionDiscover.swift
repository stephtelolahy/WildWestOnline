//
//  ActionDiscover.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct ActionDiscover: GameReducerProtocol {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        if state.arena == nil {
            state.arena = .init()
        }
        let card = try state.popDeck()
        state.arena?.add(card)
        return state
    }
}
