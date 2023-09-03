//
//  ActionGroup.swift
//  
//
//  Created by Hugues Telolahy on 07/05/2023.
//

struct ActionGroup: GameReducerProtocol {
    let children: [GameAction]

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.queue.insert(contentsOf: children, at: 0)
        return state
    }
}
