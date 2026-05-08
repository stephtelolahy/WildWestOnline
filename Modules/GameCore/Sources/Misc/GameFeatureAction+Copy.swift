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
        requiredMisses: Int? = nil,
        alias: String? = nil,
        selectors: [Card.Selector]? = nil,
    ) -> Self {
        .init(
            name: self.name,
            sourcePlayer: sourcePlayer ?? self.sourcePlayer,
            sourceCard: playedCard ?? self.sourceCard,
            triggeredBy: triggeredBy ?? self.triggeredBy,
            targetedPlayer: targetedPlayer ?? self.targetedPlayer,
            targetedCard: targetedCard ?? self.targetedCard,
            amount: amount ?? self.amount,
            requiredMisses: requiredMisses ?? self.requiredMisses,
            selection: self.selection,
            alias: alias ?? self.alias,
            playableCards: self.playableCards,
            children: self.children,
            selectors: selectors ?? self.selectors,
        )
    }

    func copy(
        targetedCard: String,
        state: GameFeature.State
    ) -> Self {
        var copy = self
        copy.targetedCard = targetedCard
        NonStandardLogic.updateActionNameByTargetedCard(action: &copy, state: state)
        return copy
    }
}
