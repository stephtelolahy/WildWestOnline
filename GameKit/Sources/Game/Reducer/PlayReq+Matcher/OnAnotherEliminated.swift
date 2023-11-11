//
//  OnAnotherEliminated.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

struct OnAnotherEliminated: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .eliminate(player) = state.event,
           player != ctx.actor {
            true
        } else {
            false
        }
    }
}
