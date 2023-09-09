//
//  ActionPlayImmediate.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct ActionPlayImmediate: GameReducerProtocol {
    let player: String
    let card: String
    let target: String?

    func reduce(state: GameState) throws -> GameState {
        // discard card from hand
        var state = state
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state.discard.push(card)

        // save played card
        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1
        return state
    }
}
