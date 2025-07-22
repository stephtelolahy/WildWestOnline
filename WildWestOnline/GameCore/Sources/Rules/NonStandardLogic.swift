//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//

enum NonStandardLogic {
    static func targetedPlayerForChildEffect(_ name: Card.Effect.Name, parentAction: Card.Effect) -> String? {
        switch name {
        case .activate,
                .preparePlay,
                .play,
                .equip,
                .handicap,
                .draw,
                .discover,
                .stealHand,
                .stealInPlay,
                .passInPlay:
            parentAction.targetedPlayer

        default:
            parentAction.player
        }
    }

    static func areActionsEqual(_ lhs: Card.Effect, _ rhs: Card.Effect) -> Bool {
        switch lhs.name {
        case .preparePlay, .play, .equip, .handicap:
            guard lhs.playedCard == rhs.playedCard
            else {
                return false
            }

        default:
            break
        }

        switch lhs.name {
        case .preparePlay, .play, .equip, .handicap, .stealHand, .stealInPlay, .passInPlay:
            guard lhs.player == rhs.player
            else {
                return false
            }

        default:
            break
        }

        return lhs.name == rhs.name
        && lhs.targetedPlayer == rhs.targetedPlayer
        && lhs.targetedCard == rhs.targetedCard
        && lhs.amount == rhs.amount
        && lhs.chosenOption == rhs.chosenOption
        && lhs.nestedEffects == rhs.nestedEffects
        && lhs.affectedCards == rhs.affectedCards
        && lhs.amountPerTurn == rhs.amountPerTurn
        && lhs.selectors == rhs.selectors
    }
}
