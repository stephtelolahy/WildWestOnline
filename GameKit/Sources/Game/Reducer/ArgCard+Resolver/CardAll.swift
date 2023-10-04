//
//  CardAll.swift
//  
//
//  Created by Hugues Telolahy on 18/05/2023.
//

struct CardAll: ArgCardResolver {
    func resolve(state: GameState, ctx: ArgCardContext) -> CardArgOutput {
        let playerObj = state.player(ctx.owner)
        let all = playerObj.inPlay.cards + playerObj.hand.cards
        return .identified(all)
    }
}
