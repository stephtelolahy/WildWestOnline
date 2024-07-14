//
//  EffectCancelTurn.swift
//  
//
//  Created by Hugues Telolahy on 14/07/2024.
//

struct EffectCancelTurn: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> SequenceState {
        var sequence = state.sequence

        let actionsToCancel = sequence.queue.filter {
            $0.isEffectOfStartTurn(ignoredCard: ctx.sourceCard)
        }

        for actionToCancel in actionsToCancel {
            sequence.cancel(actionToCancel)
        }

        return sequence
    }
}

extension SequenceState {
    mutating func cancel(_ action: GameAction) {
        if let index = queue.firstIndex(of: action) {
            queue.remove(at: index)
            removeEffectsLinkedTo(action)
        }
    }
}

private extension SequenceState {
    mutating func removeEffectsLinkedTo(_ action: GameAction) {
        if case let .effect(effect, effectCtx) = action,
           case .prepareShoot = effect,
           let target = effectCtx.resolvingTarget {
            removeEffectsLinkedToShoot(target)
        }
    }

    mutating func removeEffectsLinkedToShoot(_ target: String) {
        queue.removeAll { item in
            if case let .effect(_, ctx) = item,
               ctx.linkedToShoot == target {
                return true
            } else {
                return false
            }
        }
    }
}
