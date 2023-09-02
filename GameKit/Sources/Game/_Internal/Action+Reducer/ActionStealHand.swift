//
//  ActionStealHand.swift
//  
//
//  Created by Hugues Telolahy on 02/09/2023.
//

struct ActionStealHand: GameReducerProtocol {
    let player: String
    let target: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        try state[keyPath: \GameState.players[target]]?.hand.remove(card)
        state[keyPath: \GameState.players[player]]?.hand.add(card)
        return state
    }
}
