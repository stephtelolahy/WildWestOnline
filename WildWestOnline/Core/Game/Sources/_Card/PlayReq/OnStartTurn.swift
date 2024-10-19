//
//  OnStartTurn.swift
//  
//
//  Created by Hugues Telolahy on 03/05/2023.
//

struct OnStartTurn: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .startTurn(turn) = ctx.event,
              turn == ctx.actor {
            true
        } else {
            false
        }
    }
}
