//
//  CardInPlayWithAttribute.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 07/09/2023.
//

struct CardPreviousInPlayWithAttribute: ArgCardResolver {
    let key: AttributeKey

    func resolve(state: GameState, ctx: ArgCardContext) -> CardArgOutput {
        let player = ctx.owner
        let playerObj = state.player(player)
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