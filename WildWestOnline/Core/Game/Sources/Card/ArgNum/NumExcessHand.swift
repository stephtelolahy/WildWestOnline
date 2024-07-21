//
//  NumExcessHand.swift
//
//
//  Created by Hugues Telolahy on 02/05/2023.
//

struct NumExcessHand: ArgNumResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        let handCount = state.field.hand.getOrEmpty(ctx.sourceActor).count
        let handlLimit = state.player(ctx.sourceActor).handLimitAtEndOfTurn
        return max(handCount - handlLimit, 0)
    }
}

private extension Player {
    var handLimitAtEndOfTurn: Int {
        attributes[.handLimit] ?? health
    }
}
