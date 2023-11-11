//
//  EffectCancelTurn.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 07/11/2023.
//

struct EffectCancelTurn: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let effectsToCancel = state.queue.filter {
            $0.isEffectOfSetTurn(ignoredCard: ctx.card)
        }
        return effectsToCancel.map { .cancel($0) }
    }
}
