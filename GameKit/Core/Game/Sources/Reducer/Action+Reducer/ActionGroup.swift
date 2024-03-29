//
//  ActionGroup.swift
//  
//
//  Created by Hugues Telolahy on 07/05/2023.
//

struct ActionGroup: GameActionReducer {
    let children: [GameAction]

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.sequence.insert(contentsOf: children, at: 0)
        return state
    }
}
