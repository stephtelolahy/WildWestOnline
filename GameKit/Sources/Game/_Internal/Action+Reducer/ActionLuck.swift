//
//  ActionLuck.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct ActionLuck: GameReducerProtocol {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        let card = try state.popDeck()
        state.discard.push(card)
        return state
    }
}
