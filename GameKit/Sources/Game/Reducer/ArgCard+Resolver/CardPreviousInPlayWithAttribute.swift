//
//  CardInPlayWithAttribute.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 07/09/2023.
//

struct CardPreviousInPlayWithAttribute: ArgCardResolver {
    let key: String

    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let owner = ctx.player()
        let playerObj = state.player(owner)
        var matchedCards: [String] = []
        for card in playerObj.inPlay.cards {
            let cardName = card.extractName()
            if let cardObj = state.cardRef[cardName],
               cardObj.attributes.keys.contains(key) {
                matchedCards.append(card)
            }
        }

        guard matchedCards.count >= 2 else {
            return .identified([])
        }

        return .identified(matchedCards.dropLast())
    }
}
