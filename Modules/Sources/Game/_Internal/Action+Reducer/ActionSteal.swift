//
//  ActionSteal.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct ActionSteal: GameReducerProtocol {
    let player: String
    let target: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        try state[keyPath: \GameState.players[target]]?.removeCard(card)
        state[keyPath: \GameState.players[player]]?.hand.add(card)
        return state
    }
}
