//
//  CardEffect+Instance.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 27/10/2025.
//
extension Card.Effect {
    func toInstance(
        withPlayer sourcePlayer: String,
        playedCard: String,
        triggeredBy: [GameFeature.Action],
        targetedPlayer: String? = nil,
        targetedCard: String? = nil,
        alias: String? = nil
    ) -> GameFeature.Action {
        .init(
            actionID: self.actionID,
            name: self.action,
            sourcePlayer: sourcePlayer,
            playedCard: playedCard,
            triggeredBy: triggeredBy,
            targetedPlayer: targetedPlayer,
            targetedCard: targetedCard,
            amount: self.amount,
            alias: alias,
            selectors: self.selectors
        )
    }
}
