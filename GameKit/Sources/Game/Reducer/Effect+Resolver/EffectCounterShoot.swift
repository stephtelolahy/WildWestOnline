//
//  EffectCounterShoot.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 07/11/2023.
//

struct EffectCounterShoot: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        if let index = state.queue.firstIndex(where: { $0.isEffectOfShoot(ctx.actor) }) {
            return [.cancel(state.queue[index])]
        } else {
            throw GameError.noShootToCounter
        }
    }
}