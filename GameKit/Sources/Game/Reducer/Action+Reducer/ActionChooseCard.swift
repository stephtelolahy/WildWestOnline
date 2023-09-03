//
//  ActionChooseCard.swift
//  
//
//  Created by Hugues Telolahy on 11/04/2023.
//

struct ActionChooseCard: GameReducerProtocol {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        try state.arena?.remove(card)
        if state.arena?.cards.isEmpty == true {
            state.arena = nil
        }
        state[keyPath: \GameState.players[player]]?.hand.add(card)
        return state
    }
}
