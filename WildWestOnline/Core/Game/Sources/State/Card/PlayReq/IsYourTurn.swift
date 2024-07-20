//
//  IsYourTurn.swift
//  
//
//  Created by Hugues Telolahy on 05/11/2023.
//

struct IsYourTurn: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        ctx.actor == state.round.turn
    }
}
