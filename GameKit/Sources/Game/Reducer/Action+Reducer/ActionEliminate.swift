//
//  ActionEliminate.swift
//  
//
//  Created by Hugues Telolahy on 05/05/2023.
//

struct ActionEliminate: GameActionReducer {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.playOrder.removeAll { $0 == player }
        state.sequence.removeAll { $0.isEffectTriggeredBy(player) }
        return state
    }
}
