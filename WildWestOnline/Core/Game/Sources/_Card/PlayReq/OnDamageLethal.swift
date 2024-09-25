//
//  OnDamageLethal.swift
//
//
//  Created by Hugues Telolahy on 05/05/2023.
//

struct OnDamageLethal: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .damage(_, player) = ctx.event,
           player == ctx.actor,
           state.player(player).health <= 0 {
            true
        } else {
            false
        }
    }
}
