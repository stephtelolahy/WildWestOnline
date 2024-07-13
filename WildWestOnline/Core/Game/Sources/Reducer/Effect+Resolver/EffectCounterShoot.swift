//
//  EffectCounterShoot.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 07/11/2023.
//

struct EffectCounterShoot: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        guard let index = state.sequence.queue.firstIndex(where: { $0.isEffectOfShoot(ctx.sourceActor) }) else {
            throw SequenceState.Error.noShootToCounter
        }

        let action = state.sequence.queue[index]
        guard case .effect(let cardEffect, let effectCtx) = action,
              case .prepareShoot(let missesRequired) = cardEffect else {
            fatalError("unexpected action to counter")
        }

        let misses = try missesRequired.resolve(state: state, ctx: effectCtx)

        if misses == 1 {
            return [.cancel(action)]
        } else {
            return [.counterShoot(action)]
        }
    }
}
