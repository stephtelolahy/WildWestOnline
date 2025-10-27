//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//

enum NonStandardLogic {
    static func targetedPlayerForChildEffect(_ name: Card.EffectName, parentAction: Card.Effect) -> String? {
        switch name {
        case .drawDeck,
                .drawDiscard,
                .drawDiscovered,
                .discardHand,
                .discardInPlay,
                .heal,
                .setWeapon,
                .setPlayLimitPerTurn,
                .increaseMagnifying,
                .increaseRemoteness,
                .shoot,
                .damage,
                .choose,
                .counterShot,
                .endGame,
                .eliminate,
                .endTurn,
                .startTurn:
            return parentAction.targetedPlayer ?? parentAction.sourcePlayer

        case .draw:
            return nil

        default:
            return parentAction.targetedPlayer
        }
    }

    static func areActionsEqual(_ lhs: Card.Effect, _ rhs: Card.Effect) -> Bool {
        switch lhs.name {
        case .preparePlay,
                .play,
                .equip,
                .handicap:
            guard lhs.sourcePlayer == rhs.sourcePlayer,
                  lhs.playedCard == rhs.playedCard
            else {
                return false
            }

        case .stealHand,
                .stealInPlay,
                .passInPlay:
            guard lhs.sourcePlayer == rhs.sourcePlayer
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
