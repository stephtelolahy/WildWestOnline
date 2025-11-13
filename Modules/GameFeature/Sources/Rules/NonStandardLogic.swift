//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//

enum NonStandardLogic {
    static func targetedPlayerForChildEffect(_ name: Card.ActionName, parentAction: GameFeature.Action) -> String? {
        switch name {
        case .endGame,
                .draw,
                .discover,
                .undiscover:
            return nil

        case .drawDeck,
                .discardInPlay,
                .heal,
                .setWeapon,
                .setPlayLimitsPerTurn,
                .increaseMagnifying,
                .increaseRemoteness,
                .endTurn:
            return parentAction.targetedPlayer ?? parentAction.sourcePlayer

        default:
            return parentAction.targetedPlayer
        }
    }

    static func areActionsEqual(_ lhs: GameFeature.Action, _ rhs: GameFeature.Action) -> Bool {
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
