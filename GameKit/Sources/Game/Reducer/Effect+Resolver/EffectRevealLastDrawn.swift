//
//  EffectRevealLastDrawn.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 10/11/2023.
//

struct EffectRevealLastDrawn: EffectResolver {
    let regex: String
    let onSuccess: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let playerObj = state.player(ctx.actor)
        guard let lastDrawn = playerObj.hand.cards.last else {
            fatalError("hand should not be empty")
        }

        var result: [GameAction] = [.reveal(lastDrawn, player: ctx.actor)]

        if lastDrawn.matches(regex: regex) {
            result.append(.effect(onSuccess, ctx: ctx))
        }

        return result
    }
}
