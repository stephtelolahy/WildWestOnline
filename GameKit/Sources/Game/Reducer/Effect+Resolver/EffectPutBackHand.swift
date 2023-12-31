//
//  EffectPutBackHand.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 21/12/2023.
//

struct EffectPutBackHand: EffectResolver {
    let among: ArgNum

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.player()
        let number = try among.resolve(state: state, ctx: ctx)
        let card = ArgCard.selectLastHand(number)
        return try card.resolve(state: state, ctx: ctx) {
            .putBackHand($0, player: player)
        }
    }
}
