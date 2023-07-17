//
//  CardAll.swift
//  
//
//  Created by Hugues Telolahy on 18/05/2023.
//

struct CardAll: CardArgResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext, chooser: String, owner: String?) -> CardArgOutput {
        let playerObj = state.player(ctx.get(.actor))
        let all = playerObj.inPlay.cards + playerObj.hand.cards
        return .identified(all)
    }
}
