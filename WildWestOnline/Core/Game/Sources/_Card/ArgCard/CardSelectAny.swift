//
//  CardSelectAny.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct CardSelectAny: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        let chooser = ctx.resolvingChooser ?? owner
        var options: [CardArgOption] = []

        let inPlayCards = state.field.inPlay.get(owner)
        let inPlayOptions = inPlayCards.toCardOptions()
        options.append(contentsOf: inPlayOptions)

        let handCards = state.field.hand.get(owner)
        if chooser != owner {
            let handOptions = handCards.indices.map {
                CardArgOption(id: handCards[$0], label: "\(String.hiddenHand)-\($0)")
            }
            options.append(contentsOf: handOptions)
        } else {
            let handOptions = handCards.toCardOptions()
            options.append(contentsOf: handOptions)
        }

        return .selectable(options)
    }
}
