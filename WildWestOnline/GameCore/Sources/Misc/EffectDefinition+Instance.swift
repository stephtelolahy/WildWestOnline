//
//  EffectDefinition+Instance.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 27/10/2025.
//

extension Card.EffectDefinition {
    func toInstance(
        withPlayer sourcePlayer: String,
        playedCard: String,
        triggeredBy: Card.Effect,
        targetedPlayer: String?,
        targetedCard: String? = nil,
    ) -> Card.Effect {
        .init(
            name: action,
            sourcePlayer: sourcePlayer,
            playedCard: playedCard,
            triggeredBy: [triggeredBy],
            targetedPlayer: targetedPlayer,
            targetedCard: targetedCard,
            amount: amount,
            amountPerTurn: amountPerTurn,
            selectors: selectors
        )
    }
}
