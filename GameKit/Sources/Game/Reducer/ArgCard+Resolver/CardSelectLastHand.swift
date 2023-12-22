//
//  CardSelectLastHand.swift
//  
//
//  Created by Hugues Telolahy on 22/12/2023.
//

struct CardSelectLastHand: ArgCardResolver {
    let count: Int

    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.player()
        let playerObj = state.player(owner)
        let options = playerObj.hand.suffix(count).toCardOptions()
        return .selectable(options)
    }
}
