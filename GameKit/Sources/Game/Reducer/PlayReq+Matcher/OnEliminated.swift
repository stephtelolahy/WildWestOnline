//
//  OnEliminated.swift
//  
//
//  Created by Hugues Telolahy on 16/05/2023.
//

struct OnEliminated: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .eliminate(player) = state.event,
           player == ctx.actor {
            true
        } else {
            false
        }
    }
}
