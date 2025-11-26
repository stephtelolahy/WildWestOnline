//
//  Effect+Instance.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 27/10/2025.
//

extension Card.Effect {
    func toInstance(
        withPlayer sourcePlayer: String,
        playedCard: String,
        triggeredBy: [GameFeature.Action],
        targetedPlayer: String?,
        targetedCard: String? = nil,
    ) -> GameFeature.Action {
        .init(
            name: action,
            sourcePlayer: sourcePlayer,
            playedCard: playedCard,
            targetedPlayer: targetedPlayer,
            targetedCard: targetedCard,
            triggeredBy: triggeredBy,
            amount: amount,
            modifier: modifier,
            selectors: selectors
        )
    }
}
