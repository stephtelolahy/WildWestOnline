//
//  ActionDamage.swift
//  
//
//  Created by Hugues Telolahy on 16/04/2023.
//

struct ActionDamage: GameReducerProtocol {
    let player: String
    let value: Int

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \GameState.players[player]]?.looseHealth(value)
        return state
    }
}
