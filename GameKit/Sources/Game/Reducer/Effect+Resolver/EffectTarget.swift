//
//  EffectTarget.swift
//  
//
//  Created by Hugues Telolahy on 22/04/2023.
//

struct EffectTarget: EffectResolverProtocol {
    let target: ArgPlayer
    let effect: CardEffect
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        try target.resolve(state: state, ctx: ctx) {
            .effect(effect, ctx: ctx.copy([.target: $0]))
        }
    }
}
