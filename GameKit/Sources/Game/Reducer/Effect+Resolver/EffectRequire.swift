//
//  EffectRequire.swift
//  
//
//  Created by Hugues Telolahy on 15/10/2023.
//

struct EffectRequire: EffectResolver {
    let condition: StateCondition
    let effect: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let playReqContext = PlayReqContext(actor: ctx.actor)
        try condition.match(state: state, ctx: playReqContext)
        return [.effect(effect, ctx: ctx)]
    }
}
