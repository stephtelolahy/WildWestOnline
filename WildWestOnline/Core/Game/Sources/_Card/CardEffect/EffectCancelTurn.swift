//
//  EffectCancelTurn.swift
//  
//
//  Created by Hugues Telolahy on 14/07/2024.
//

struct EffectCancelTurn: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        /*

        let actions = state.queue.filter {
            $0.isEffectOfStartTurn(ignoredCard: ctx.sourceCard)
        }
        return .cancel(actions)

         */
        fatalError()
    }
}
