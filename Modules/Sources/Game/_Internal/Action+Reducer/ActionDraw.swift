//
//  ActionDraw.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct ActionDraw: GameReducerProtocol {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        let card = try state.popDeck()
        state[keyPath: \GameState.players[player]]?.hand.add(card)
        return state
    }
}
