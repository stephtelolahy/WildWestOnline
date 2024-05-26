//
//  ActionHeal.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct ActionHeal: GameActionReducer {
    let player: String
    let amount: Int

    func reduce(state: GameState) throws -> GameState {
        var state = state
        try state[keyPath: \GameState.players[player]]?.gainHealth(amount)
        return state
    }
}
