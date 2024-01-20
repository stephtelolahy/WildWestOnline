//
//  IsHandAtLeast.swift
//  
//
//  Created by Hugues Telolahy on 21/01/2024.
//

struct IsHandAtLeast: PlayReqMatcher {
    let minCount: Int

    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        state.player(ctx.actor).hand.count >= minCount
    }
}
