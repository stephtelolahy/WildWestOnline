//
//  ActionDrawHand.swift
//  
//
//  Created by Hugues Telolahy on 02/09/2023.
//

struct ActionDrawHand: GameActionReducer {
    let player: String
    let target: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \GameState.players[target]]?.hand.remove(card)
        state[keyPath: \GameState.players[player]]?.hand.append(card)
        return state
    }
}
