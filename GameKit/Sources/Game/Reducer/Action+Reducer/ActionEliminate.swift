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
        state.playOrder.removeAll(where: { $0 == player })
        state.queue.removeAll(where: { $0.isEffectTriggeredByPlayer(player) })
        return state
    }
}
