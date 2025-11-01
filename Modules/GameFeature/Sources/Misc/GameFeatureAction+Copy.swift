//
//  GameFeatureAction+Copy.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 27/10/2025.
//

extension GameFeature.Action {
    func copy(
        withPlayer sourcePlayer: String? = nil,
        playedCard: String? = nil,
        triggeredBy: [Self]? = nil,
        targetedPlayer: String? = nil,
        targetedCard: String? = nil,
        amount: Int? = nil,
        selectors: [Card.Selector]? = nil,
    ) -> Self {
        .init(
            name: self.name,
            sourcePlayer: sourcePlayer ?? self.sourcePlayer,
            playedCard: playedCard ?? self.playedCard,
            triggeredBy: triggeredBy ?? self.triggeredBy,
            targetedPlayer: targetedPlayer ?? self.targetedPlayer,
            targetedCard: targetedCard ?? self.targetedCard,
            amount: amount ?? self.amount,
            chosenOption: self.chosenOption,
            nestedEffects: self.nestedEffects,
            affectedCards: self.affectedCards,
            amountPerTurn: self.amountPerTurn,
            selectors: selectors ?? self.selectors
        )
    }
}
