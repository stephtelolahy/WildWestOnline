//
//  CardAll.swift
//  
//
//  Created by Hugues Telolahy on 18/05/2023.
//

struct CardAll: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.target!
        let playerObj = state.player(owner)
        let all = playerObj.inPlay.cards + playerObj.hand.cards
        return .identified(all)
    }
}
