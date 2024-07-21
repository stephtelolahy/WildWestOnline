//
//  EffectDrawArena.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectDrawArena: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        let children = try ArgCard.selectArena.resolve(.cardToDraw, state: state, ctx: ctx) {
            .drawArena($0, player: ctx.targetOrActor())
        }
        return .push(children)
    }
}
