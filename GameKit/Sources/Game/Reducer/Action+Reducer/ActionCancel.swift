//
//  ActionCancel.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 22/06/2023.
//

struct ActionCancel: GameActionReducer {
    let action: GameAction

    func reduce(state: GameState) throws -> GameState {
        var state = state
        if let index = state.queue.firstIndex(of: action) {
            state.queue.remove(at: index)
            state.removeEffectsLinkedTo(action)
        }

        return state
    }
}

private extension GameState {
    mutating func removeEffectsLinkedTo(_ action: GameAction) {
        queue.removeAll { item in
            if case let .effect(_, ctx) = item,
               ctx.linkedAction == action {
                return true
            } else {
                return false
            }
        }
    }
}
