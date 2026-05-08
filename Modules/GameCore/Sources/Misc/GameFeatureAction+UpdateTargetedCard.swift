//
//  GameFeatureAction+UpdateWithTargetedCard.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 08/05/2026.
//

extension GameFeature.Action {
    func updateWithTargetedCard(_ card: String, state: GameFeature.State) -> Self {
        var copy = self
        copy.targetedCard = card
        NonStandardLogic.updateActionNameByTargetedCard(action: &copy, state: state)
        return copy
    }
}
