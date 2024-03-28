//
//  NumDamage.swift
//
//
//  Created by Hugues Telolahy on 03/11/2023.
//

struct NumDamage: ArgNumResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        guard case let .damage(amount, player) = ctx.sourceEvent,
              player == ctx.sourceActor else {
            fatalError("invalid triggering action")
        }

        return amount
    }
}
