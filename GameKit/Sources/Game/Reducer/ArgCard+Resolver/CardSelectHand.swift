//
//  CardSelectHand.swift
//  
//
//  Created by Hugues Telolahy on 02/05/2023.
//

struct CardSelectHand: ArgCardResolver {
    func resolve(state: GameState, ctx: ArgCardContext) -> CardArgOutput {
        let playerObj = state.player(ctx.owner)
        let options = playerObj.hand.cards.toCardOptions()

        return .selectable(options)
    }
}
