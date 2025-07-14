//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//

enum NonStandardLogic {
    /// Determine child effect's target
    static func childEffectTarget(
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
            payload.target

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
                lhs.payload.played == rhs.payload.played
            else {
                return false
            }

        default:
            break
        }

        return lhs.name == rhs.name
        && lhs.selectors == rhs.selectors
        && lhs.payload.target == rhs.payload.target
        && lhs.payload.card == rhs.payload.card
        && lhs.payload.amount == rhs.payload.amount
        && lhs.payload.selection == rhs.payload.selection
        && lhs.payload.children == rhs.payload.children
        && lhs.payload.cards == rhs.payload.cards
        && lhs.payload.amountPerTurn == rhs.payload.amountPerTurn
    }
}
