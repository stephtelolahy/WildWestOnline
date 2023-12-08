//
//  CardAll.swift
//  
//
//  Created by Hugues Telolahy on 18/05/2023.
//

struct CardAll: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.player()
        let playerObj = state.player(owner)
        let all = playerObj.inPlay + playerObj.hand
        return .identified(all)
    }
}
