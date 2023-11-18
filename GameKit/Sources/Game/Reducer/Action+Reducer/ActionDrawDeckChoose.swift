//
//  ActionDrawDeckChoose.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

struct ActionDrawDeckChoose: GameActionReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state

        try state.deck.remove(card)
        state[keyPath: \GameState.players[player]]?.hand.add(card)
        return state
    }
}
