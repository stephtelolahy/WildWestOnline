//
//  EffectCounterShoot.swift
//  
//
//  Created by Hugues Telolahy on 14/07/2024.
//

struct EffectCounterShoot: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        guard let index = state.sequence.queue.firstIndex(where: { $0.isEffectOfShoot(ctx.sourceActor) }) else {
            throw SequenceState.Error.noShootToCounter
        }

        let shootAction = state.sequence.queue[index]
        guard case .prepareEffect(let cardEffect, let effectCtx) = shootAction,
              case .prepareShoot(let missesRequired) = cardEffect else {
            fatalError("unexpected action to counter")
        }

        let misses = try missesRequired.resolve(state: state, ctx: effectCtx)

        if misses == 1 {
            return .cancel([shootAction])
        } else {
            let remainingMisses = ArgNum.exact(misses - 1)
            let updatedAction = GameAction.prepareEffect(.prepareShoot(missesRequired: remainingMisses), ctx: effectCtx)
            return .replace(index, with: updatedAction)
        }
    }
}
