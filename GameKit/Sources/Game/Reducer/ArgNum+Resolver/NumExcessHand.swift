//
//  NumExcessHand.swift
//  
//
//  Created by Hugues Telolahy on 02/05/2023.
//

struct NumExcessHand: ArgNumResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        let playerObj = state.player(ctx.actor)
        return max(playerObj.hand.count - playerObj.handLimitAtEndOfTurn(), 0)
    }
}
