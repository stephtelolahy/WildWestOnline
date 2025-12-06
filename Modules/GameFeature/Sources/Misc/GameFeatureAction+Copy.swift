//
//  GameFeatureAction+Copy.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 27/10/2025.
//
import CardDefinition

extension GameFeature.Action {
    func copy(
        withPlayer sourcePlayer: String? = nil,
        playedCard: String? = nil,
        triggeredBy: [Self]? = nil,
        targetedPlayer: String? = nil,
        targetedCard: String? = nil,
        amount: Int? = nil,
        requiredMisses: Int? = nil,
        alias: String? = nil,
        selectors: [Card.Selector]? = nil,
    ) -> Self {
        .init(
            name: self.name,
            sourcePlayer: sourcePlayer ?? self.sourcePlayer,
            playedCard: playedCard ?? self.playedCard,
            targetedPlayer: targetedPlayer ?? self.targetedPlayer,
            targetedCard: targetedCard ?? self.targetedCard,
            triggeredBy: triggeredBy ?? self.triggeredBy,
            amount: amount ?? self.amount,
            requiredMisses: requiredMisses ?? self.requiredMisses,
            selection: self.selection,
            alias: alias ?? self.alias,
            playableCards: self.playableCards,
            children: self.children,
            selectors: selectors ?? self.selectors,
        )
    }
}
