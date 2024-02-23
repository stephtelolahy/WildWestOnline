//
//  ActionPassInPlay.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

struct ActionPassInPlay: GameActionReducer {
    let card: String
    let target: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \GameState.players[player]]?.inPlay.remove(card)
        state[keyPath: \GameState.players[target]]?.inPlay.append(card)
        return state
    }
}
