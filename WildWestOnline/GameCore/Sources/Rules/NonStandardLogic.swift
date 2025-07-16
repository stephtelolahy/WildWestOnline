//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//

enum NonStandardLogic {
    /// Determine child effect's target
    static func targetedPlayerForChildEffect(
        _ name: Card.Effect.Name,
        payload: Card.Effect.Payload
    ) -> String? {
        switch name {
        case .choose,
                .activate,
                .preparePlay,
                .play,
                .equip,
                .handicap,
                .draw,
                .discover,
                .stealHand,
                .stealInPlay,
                .passInPlay:
            payload.targetedPlayer

        default:
            payload.player
        }
    }

    /// Equatable conformance
    static func areActionsEqual(_ lhs: Card.Effect, _ rhs: Card.Effect) -> Bool {
        switch lhs.name {
        case .queue,
                .preparePlay,
                .play,
                .equip,
                .handicap,
                .stealHand,
                .stealInPlay,
                .passInPlay,
                .choose:
            guard
                lhs.payload.player == rhs.payload.player,
                lhs.payload.playedCard == rhs.payload.playedCard
            else {
                return false
            }

        default:
            break
        }

        return lhs.name == rhs.name
        && lhs.selectors == rhs.selectors
        && lhs.payload.targetedPlayer == rhs.payload.targetedPlayer
        && lhs.payload.targetedCard == rhs.payload.targetedCard
        && lhs.payload.amount == rhs.payload.amount
        && lhs.payload.selection == rhs.payload.selection
        && lhs.payload.nestedEffects == rhs.payload.nestedEffects
        && lhs.payload.affectedCards == rhs.payload.affectedCards
        && lhs.payload.amountPerTurn == rhs.payload.amountPerTurn
    }
}
