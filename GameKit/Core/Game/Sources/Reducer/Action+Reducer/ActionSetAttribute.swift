//
//  ActionSetAttribute.swift
//  
//
//  Created by Hugues Telolahy on 30/08/2023.
//

struct ActionSetAttribute: GameActionReducer {
    let player: String
    let key: String
    let value: Int

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \GameState.players[player]]?.setValue(value, forAttribute: key)
        return state
    }
}
