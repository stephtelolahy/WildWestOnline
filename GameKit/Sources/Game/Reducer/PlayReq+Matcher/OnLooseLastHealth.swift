//
//  OnLooseLastHealth.swift
//  
//
//  Created by Hugues Telolahy on 05/05/2023.
//

struct OnLooseLastHealth: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .damage(_, player) = state.event,
              player == ctx.actor,
              state.player(player).health <= 0 {
            true
        } else {
            false
        }
    }
}
