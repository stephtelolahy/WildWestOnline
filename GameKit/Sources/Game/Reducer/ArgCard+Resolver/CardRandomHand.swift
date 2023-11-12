//
//  CardRandomHand.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

struct CardRandomHand: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.player()
        let playerObj = state.player(owner)
        guard let card = playerObj.hand.cards.randomElement() else {
            return .identified([])
        }

        return .identified([card])
    }
}
