//
//  EffectChooseCard.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectChooseCard: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let chooserId = ctx.target!
        let card = ArgCard.selectArena

        let cardContext = ArgCardContext(owner: String(), chooser: chooserId, playedCard: ctx.card)
        return try card.resolve(state: state, ctx: cardContext) {
            .chooseCard($0, player: chooserId)
        }
    }
}
