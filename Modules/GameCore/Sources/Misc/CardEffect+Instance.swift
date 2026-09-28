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
        alias: String? = nil
    ) -> GameFeature.Action {
        .init(
            name: self.action,
            sourcePlayer: sourcePlayer,
            sourceCard: playedCard,
            triggeredBy: triggeredBy,
            alias: alias,
            selectors: self.selectors
        )
    }
}
