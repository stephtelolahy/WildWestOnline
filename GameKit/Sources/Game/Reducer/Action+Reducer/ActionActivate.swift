//
//  ActionActivate.swift
//  
//
//  Created by Hugues Telolahy on 01/07/2023.
//

struct ActionActivate: GameActionReducer {
    let player: String
    let cards: [String]

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.active = ActiveCards(player: player, cards: cards)
        return state
    }
}
