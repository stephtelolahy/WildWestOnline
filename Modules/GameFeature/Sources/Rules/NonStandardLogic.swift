//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//
import CardDefinition

enum NonStandardLogic {
    static func targetedPlayerForTriggeredEffect(_ name: Card.ActionName, parentAction: GameFeature.Action) -> String? {
        switch name {
        case .endGame,
                .discover,
                .undiscover:
            return nil

        case .drawDeck,
                .draw,
                .discardInPlay,
                .heal,
                .setWeapon,
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
        && lhs.selection == rhs.selection
        && lhs.alias == rhs.alias
        && lhs.children == rhs.children
        && lhs.playableCards == rhs.playableCards
        && lhs.selectors == rhs.selectors
    }
}
