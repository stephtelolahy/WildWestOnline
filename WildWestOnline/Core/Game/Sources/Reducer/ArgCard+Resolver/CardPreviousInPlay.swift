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
        let playerObj = state.player(owner)
        var matchedCards: [String] = []
        for card in playerObj.inPlay {
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
