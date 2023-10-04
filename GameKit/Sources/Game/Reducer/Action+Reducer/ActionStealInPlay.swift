//
//  ActionStealInPlay.swift
//  
//
//  Created by Hugues Telolahy on 02/09/2023.
//

struct ActionStealInPlay: GameActionReducer {
    let player: String
    let target: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        try state[keyPath: \GameState.players[target]]?.inPlay.remove(card)
        state[keyPath: \GameState.players[player]]?.hand.add(card)
        return state
    }
}
