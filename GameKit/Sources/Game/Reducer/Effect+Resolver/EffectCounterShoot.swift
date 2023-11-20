//
//  EffectCounterShoot.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 07/11/2023.
//

struct EffectCounterShoot: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        guard let index = state.sequence.firstIndex(where: { $0.isEffectOfShoot(ctx.actor) }) else {
            throw GameError.noShootToCounter
        }

        return [.cancel(state.sequence[index])]
    }
}
