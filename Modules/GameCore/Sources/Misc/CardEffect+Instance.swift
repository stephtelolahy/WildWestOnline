//
//  CardEffect+Instance.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 27/10/2025.
//
// swiftlint:disable function_default_parameter_at_end

extension Card.Effect {
    func toInstance(
        withPlayer sourcePlayer: String,
        playedCard: String,
        triggeredBy: [GameFeature.Action],
        targetedPlayer: String? = nil,
        targetedCard: String? = nil,
        alias: String? = nil,
        state: GameFeature.State
    ) -> GameFeature.Action {
        var instance = GameFeature.Action(
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
        NonStandardLogic.updateActionNameByTargetedCard(action: &instance, state: state)
        return instance
    }
}
