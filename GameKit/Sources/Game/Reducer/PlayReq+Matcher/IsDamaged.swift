//
//  IsDamaged.swift
//  
//
//  Created by Hugues Telolahy on 21/01/2024.
//

struct IsDamaged: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        state.player(ctx.actor).isDamaged
    }
}
