//
//  CardSelectLastHand.swift
//  
//
//  Created by Hugues Telolahy on 22/12/2023.
//

struct CardSelectLastHand: ArgCardResolver {
    let count: Int

    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        let handCards = state.field.hand.getOrEmpty(owner)
        let options = handCards.suffix(count).toCardOptions()
        return .selectable(options)
    }
}
