//
//  NumExcessHand.swift
//
//
//  Created by Hugues Telolahy on 02/05/2023.
//

struct NumExcessHand: ArgNumResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        let handCount = state.player(ctx.sourceActor).hand.count
        let handlLimit = state.handLimitAtEndOfTurn(id: ctx.sourceActor)
        return max(handCount - handlLimit, 0)
    }
}

private extension GameState {
    func handLimitAtEndOfTurn(id: String) -> Int {
        players.get(id).attributes[.handLimit] ?? playersState.players.get(id).health
    }
}
