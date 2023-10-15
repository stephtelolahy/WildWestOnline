//
//  IsOutOfTurn.swift
//  
//
//  Created by Hugues Telolahy on 14/10/2023.
//

struct IsOutOfTurn: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        state.turn != ctx.actor
    }
}
