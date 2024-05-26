//
//  EffectPutBack.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 21/12/2023.
//

struct EffectPutBack: EffectResolver {
    let among: ArgNum

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.targetOrActor()
        let number = try among.resolve(state: state, ctx: ctx)
        let card = ArgCard.selectLastHand(number)
        return try card.resolve(.cardToPutBack, state: state, ctx: ctx) {
            .putBack($0, player: player)
        }
    }
}
