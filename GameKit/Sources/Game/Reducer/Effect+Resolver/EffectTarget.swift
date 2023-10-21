//
//  EffectTarget.swift
//  
//
//  Created by Hugues Telolahy on 22/04/2023.
//

struct EffectTarget: EffectResolver {
    let target: ArgPlayer
    let effect: CardEffect
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let playerContext = ArgPlayerContext(actor: ctx.actor)
        return try target.resolve(state: state, ctx: playerContext) {
            var targetedContext = ctx
            targetedContext.target = $0
            return GameAction.effect(effect, ctx: targetedContext)
        }
    }
}
