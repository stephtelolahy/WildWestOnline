//
//  CardRandomHand.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

struct CardRandomHand: ArgCardResolver {
    func resolve(state: GameState, ctx: ArgCardContext) -> CardArgOutput {
        let playerObj = state.player(ctx.owner)
        guard let card = playerObj.hand.cards.randomElement() else {
            return .identified([])
        }

        return .identified([card])
    }
}
