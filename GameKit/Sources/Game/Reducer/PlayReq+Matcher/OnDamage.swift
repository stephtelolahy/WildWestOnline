//
//  OnDamage.swift
//
//
//  Created by Hugues Telolahy on 03/11/2023.
//

struct OnDamage: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .damage(_, player) = ctx.event,
           player == ctx.actor,
           state.player(player).health > 0 {
            true
        } else {
            false
        }
    }
}
