//
//  IsCurrentTurn.swift
//  
//
//  Created by Hugues Telolahy on 16/05/2023.
//

struct IsCurrentTurn: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        state.turn == ctx.actor
    }
}
