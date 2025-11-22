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
        contextCardsPerTurn: Int = 0,
        contextAdditionalMissed: Int = 0,
        selectors: [Card.Selector]? = nil,
    ) -> Self {
        .init(
            name: self.name,
            sourcePlayer: sourcePlayer ?? self.sourcePlayer,
            playedCard: playedCard ?? self.playedCard,
            targetedPlayer: targetedPlayer ?? self.targetedPlayer,
            targetedCard: targetedCard ?? self.targetedCard,
            amount: amount ?? self.amount,
            triggeredBy: triggeredBy ?? self.triggeredBy,
            selection: self.selection,
            playableCards: self.playableCards,
            amountPerTurn: self.amountPerTurn,
            contextCardsPerTurn: self.contextCardsPerTurn + contextCardsPerTurn,
            contextAdditionalMissed: self.contextAdditionalMissed + contextAdditionalMissed,
            selectors: selectors ?? self.selectors,
            children: self.children,
        )
    }
}
