//
//  CardInPlayWithAttribute.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 07/09/2023.
//

struct CardPreviousInPlay: ArgCardResolver {
    let key: String

    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.targetOrActor()
        var matchedCards: [String] = []
        let inPlayCards = state.field.inPlay.get(owner)
        for card in inPlayCards {
            let cardName = card.extractName()
            if let cardObj = state.cards[cardName],
               cardObj.attributes.keys.contains(key) {
                matchedCards.append(card)
            }
        }

        let minExpectedMatchedCards = 2
        guard matchedCards.count >= minExpectedMatchedCards else {
            return .identified([])
        }

        return .identified(matchedCards.dropLast())
    }
}
