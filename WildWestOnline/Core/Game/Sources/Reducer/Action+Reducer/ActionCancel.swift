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
        if let index = state.sequence.queue.firstIndex(of: action) {
            state.sequence.queue.remove(at: index)
            state.removeEffectsLinkedTo(action)
        }

        return state
    }
}

private extension GameState {
    mutating func removeEffectsLinkedTo(_ action: GameAction) {
        if case let .effect(effect, effectCtx) = action,
           case .prepareShoot = effect,
           let target = effectCtx.resolvingTarget {
            removeEffectsLinkedToShoot(target)
        }
    }

    mutating func removeEffectsLinkedToShoot(_ target: String) {
        sequence.queue.removeAll { item in
            if case let .effect(_, ctx) = item,
               ctx.linkedToShoot == target {
                return true
            } else {
                return false
            }
        }
    }
}
