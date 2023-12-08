//
//  ActionRemoveAttribute.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

struct ActionRemoveAttribute: GameActionReducer {
    let player: String
    let key: AttributeKey

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \GameState.players[player]]?.setValue(nil, forAttribute: key)
        return state
    }
}
