//
//  CardAll.swift
//  
//
//  Created by Hugues Telolahy on 18/05/2023.
//

struct CardAll: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        /*
        let owner = ctx.targetOrActor()
        let inPlay = state.field.inPlay.get(owner)
        let hand = state.field.hand.get(owner)
        let all = inPlay + hand
        return .identified(all)
         */
        fatalError()
    }
}
