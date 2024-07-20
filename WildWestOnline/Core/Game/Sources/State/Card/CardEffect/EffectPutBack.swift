//
//  EffectPutBack.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 21/12/2023.
//

struct EffectPutBack: EffectResolver {
    let among: ArgNum

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        let player = ctx.targetOrActor()
        let number = try among.resolve(state: state, ctx: ctx)
        let card = ArgCard.selectLastHand(number)
        let children = try card.resolve(.cardToPutBack, state: state, ctx: ctx) {
            .putBack($0, player: player)
        }
        return .push(children)
    }
}
