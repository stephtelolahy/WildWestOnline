//
//  OnEliminatedYourTurn.swift
//  
//
//  Created by Hugues Telolahy on 15/10/2023.
//

struct OnEliminatedYourTurn: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .eliminate(player) = state.event,
           player == ctx.actor,
           player == state.turn {
            true
        } else {
            false
        }
    }
}
