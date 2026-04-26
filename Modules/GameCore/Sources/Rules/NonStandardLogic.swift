//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//
enum NonStandardLogic {
    /// Transmitting context data from parent
    static func targetedPlayerForTriggeredEffect(
        _ actionID: Card.ActionID,
        name: Card.ActionName?,
        parentAction: GameFeature.Action
    ) -> String? {
        guard let name else {
            switch actionID.rawValue {
            case "incrementRequiredMisses":
                return parentAction.targetedPlayer

            default:
                return nil
            }
        }

        switch name {
        case .drawDeck,
                .draw,
                .discardInPlay,
                .heal,
                .setWeapon,
                .increaseMagnifying,
                .increaseRemoteness,
                .endTurn:
            return parentAction.targetedPlayer ?? parentAction.sourcePlayer

        case .play,
                .drawDiscard,
                .discardHand,
                .shoot,
                .damage,
                .stealHand,
                .stealInPlay,
                .counterShot,
                .showHand,
                .drawDiscovered,
                .eliminate:
            return parentAction.targetedPlayer

        default:
            return nil
        }
    }

    /// Transmitting context data from parent
    static func targetedCardForTriggeredEffect(
        _ actionID: Card.ActionID,
        name: Card.ActionName?,
        parentAction: GameFeature.Action
    ) -> String? {
        switch name {
        case .discardHand,
                .discardInPlay,
                .stealHand,
                .stealInPlay:
            return parentAction.targetedCard

        default:
            return nil
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

        return lhs.actionID == rhs.actionID
        && lhs.name == rhs.name
        && lhs.targetedPlayer == rhs.targetedPlayer
        && lhs.targetedCard == rhs.targetedCard
        && lhs.amount == rhs.amount
        && lhs.selection == rhs.selection
        && lhs.alias == rhs.alias
        && lhs.playableCards == rhs.playableCards
        && lhs.children == rhs.children
        && lhs.selectors == rhs.selectors
    }
}
