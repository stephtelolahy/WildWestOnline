//
//  ActionCounterShoot.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 05/06/2024.
//

struct ActionCounterShoot {
    let action: GameAction

    func reduce(state: GameState) throws -> GameState {
        var state = state
        guard let index = state.sequence.queue.firstIndex(of: action) else {
            fatalError("action not found \(action)")
        }

        guard case .effect(let cardEffect, let effectCtx) = action,
              case .prepareShoot(let missesRequired) = cardEffect else {
            fatalError("unexpected action to counter")
        }

        let misses = try missesRequired.resolve(state: state, ctx: effectCtx)
        let remainingMisses = ArgNum.exact(misses - 1)
        let updatedAction = GameAction.effect(.prepareShoot(missesRequired: remainingMisses), ctx: effectCtx)
        state.sequence.queue[index] = updatedAction

        return state
    }
}
