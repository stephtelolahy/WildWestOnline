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
        triggeredBy: GameFeature.Action,
        targetedPlayer: String?,
        targetedCard: String? = nil,
    ) -> GameFeature.Action {
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
