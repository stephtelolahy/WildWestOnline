//
//  CardSelectHand.swift
//  
//
//  Created by Hugues Telolahy on 02/05/2023.
//

struct CardSelectHand: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        let playerObj = state.player(owner)
        let options = playerObj.hand.toCardOptions()

        return .selectable(options)
    }
}
