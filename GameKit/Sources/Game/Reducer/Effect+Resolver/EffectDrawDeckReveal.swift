//
//  EffectDrawDeckReveal.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 10/11/2023.
//

struct EffectDrawDeckReveal: EffectResolver {
    let regex: String
    let onSuccess: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        var state = state
        #warning("incoherent deck")
        let card = try state.popDeck()

        var result: [GameAction] = [
            .drawDeckReveal(card, player: ctx.actor)
        ]

        if card.matches(regex: regex) {
            result.append(.effect(onSuccess, ctx: ctx))
        }

        return result
    }
}
