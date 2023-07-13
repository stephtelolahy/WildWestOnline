//
//  EffectChooseCard.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectChooseCard: EffectResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let chooserId = ctx.get(.target)
        let card = CardArg.selectArena

        return try card.resolve(state: state, ctx: ctx, chooser: chooserId, owner: nil) {
            .chooseCard($0, player: chooserId)
        }
    }
}
