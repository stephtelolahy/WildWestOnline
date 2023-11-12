//
//  CardSelectHand.swift
//  
//
//  Created by Hugues Telolahy on 02/05/2023.
//

struct CardSelectHand: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.player()
        let playerObj = state.player(owner)
        let options = playerObj.hand.cards.toCardOptions()

        return .selectable(options)
    }
}
