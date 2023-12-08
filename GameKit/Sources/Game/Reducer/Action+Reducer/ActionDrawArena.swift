//
//  ActionDrawArena.swift
//  
//
//  Created by Hugues Telolahy on 11/04/2023.
//

struct ActionDrawArena: GameActionReducer {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.arena.remove(card)
        state[keyPath: \GameState.players[player]]?.hand.append(card)
        return state
    }
}
