//
//  TriggerConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 06/04/2025.
//

extension Card.TriggerCondition {
    func match(event: Card.Effect, player: String, state: GameFeature.State) -> Bool {
        event.name == name
        && event.payload.targetedPlayer == player
        && conditions.allSatisfy {
            $0.match(.init(player: player), state: state)
        }
    }
}
