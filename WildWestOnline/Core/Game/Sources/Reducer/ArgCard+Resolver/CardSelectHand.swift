//
//  CardSelectHand.swift
//  
//
//  Created by Hugues Telolahy on 02/05/2023.
//

struct CardSelectHand: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        let chooser = ctx.resolvingChooser ?? owner
        let playerObj = state.player(owner)
        let options: [CardArgOption]

        if chooser != owner {
            let handCards = state.field.hand.get(owner)
            options = handCards.indices.map {
                CardArgOption(
                    id: handCards[$0],
                    label: "\(String.hiddenHand)-\($0)"
                )
            }
        } else {
            options = state.field.hand.get(owner).toCardOptions()
        }

        return .selectable(options)
    }
}
