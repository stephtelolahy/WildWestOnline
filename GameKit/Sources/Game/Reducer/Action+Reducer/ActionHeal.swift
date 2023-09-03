//
//  ActionHeal.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct ActionHeal: GameReducerProtocol {
    let player: String
    let value: Int

    func reduce(state: GameState) throws -> GameState {
        var state = state
        try state[keyPath: \GameState.players[player]]?.gainHealth(value)
        return state
    }
}
