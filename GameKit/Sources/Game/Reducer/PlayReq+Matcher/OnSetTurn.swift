//
//  OnSetTurn.swift
//  
//
//  Created by Hugues Telolahy on 03/05/2023.
//

struct OnSetTurn: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .setTurn(turn) = state.event,
              turn == ctx.actor {
            true
        } else {
            false
        }
    }
}
