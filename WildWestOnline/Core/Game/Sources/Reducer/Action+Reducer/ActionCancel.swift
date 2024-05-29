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
        if let index = state.sequence.firstIndex(of: action) {
            state.sequence.remove(at: index)
            state.removeEffectsLinkedTo(action)
        }

        return state
    }
}

private extension GameState {
    mutating func removeEffectsLinkedTo(_ action: GameAction) {
        guard case let .effect(effect, effectCtx) = action,
              case .prepareShoot = effect,
              let target = effectCtx.resolvingTarget else {
            return
        }

        sequence.removeAll { item in
            if case let .effect(_, ctx) = item,
               ctx.linkedToShoot == target {
                return true
            } else {
                return false
            }
        }
    }
}
