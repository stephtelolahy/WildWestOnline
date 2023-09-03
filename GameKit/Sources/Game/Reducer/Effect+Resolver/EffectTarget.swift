//
//  EffectTarget.swift
//  
//
//  Created by Hugues Telolahy on 22/04/2023.
//

struct EffectTarget: EffectResolverProtocol {
    let target: PlayerArg
    let effect: CardEffect
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        try target.resolve(state: state, ctx: ctx) {
            .resolve(effect, ctx: ctx.copy([.target: $0]))
        }
    }
}
