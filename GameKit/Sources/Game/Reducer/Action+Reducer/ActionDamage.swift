//
//  ActionDamage.swift
//  
//
//  Created by Hugues Telolahy on 16/04/2023.
//

struct ActionDamage: GameActionReducer {
    let player: String
    let amount: Int

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \GameState.players[player]]?.looseHealth(amount)
        return state
    }
}
