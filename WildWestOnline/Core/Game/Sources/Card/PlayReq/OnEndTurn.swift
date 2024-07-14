//
//  OnEndTurn.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 25/05/2024.
//

struct OnEndTurn: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .endTurn(player) = ctx.event,
           player == ctx.actor {
            true
        } else {
            false
        }
    }
}
