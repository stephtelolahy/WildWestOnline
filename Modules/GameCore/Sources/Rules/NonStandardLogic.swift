//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//
enum NonStandardLogic {
    /// Transmitting context data from parent
    static func targetedPlayerForTriggeredEffect(
        name: Card.ActionName,
        parentAction: GameFeature.Action
    ) -> String? {
        switch name {
        case .drawDeck,
                .draw,
                .discard,
                .heal,
                .setWeapon,
                .increaseMagnifying,
                .increaseRemoteness,
                .endTurn:
            return parentAction.targetedPlayer ?? parentAction.sourcePlayer

        case .play,
                .drawDiscard,
                .shoot,
                .damage,
                .steal,
                .counterShot,
                .showHand,
                .drawDiscovered,
                .eliminate,
                .incrementRequiredMisses:
            return parentAction.targetedPlayer

        default:
            return nil
        }
    }

    /// Transmitting context data from parent
    static func targetedCardForTriggeredEffect(
        name: Card.ActionName,
        parentAction: GameFeature.Action
    ) -> String? {
        switch name {
        case .discard, .steal:
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

        return lhs.name == rhs.name
        && lhs.targetedPlayer == rhs.targetedPlayer
        && lhs.targetedCard == rhs.targetedCard
        && lhs.amount == rhs.amount
        && lhs.selection == rhs.selection
        && lhs.alias == rhs.alias
        && lhs.playableCards == rhs.playableCards
        && lhs.children == rhs.children
        && lhs.selectors == rhs.selectors
    }

    static func isActionVisible(_ action: GameFeature.Action) -> Bool {
        switch action.name {
        case .queue,
                .discard,
                .steal,
                .incrementRequiredMisses,
                .ignoreLimitPerTurn,
                .incrementCardsPerTurn:
            return false

        default:
            break
        }

        return true
    }

    static func updateActionNameByTargetedCard(
        action: inout  GameFeature.Action,
        state: GameFeature.State
    ) {
        switch action.name {
        case .discard:
            let player = action.targetedPlayer ?? action.sourcePlayer
            guard let card = action.targetedCard else {
                return
            }
            let playerObj = state.players.get(player)
            if playerObj.hand.contains(card) {
                action.name = .discardHand
            }
            if playerObj.inPlay.contains(card) {
                action.name = .discardInPlay
            }

        case .steal:
            guard let player = action.targetedPlayer,
                  let card = action.targetedCard else {
                return
            }
            let playerObj = state.players.get(player)
            if playerObj.hand.contains(card) {
                action.name = .stealHand
            }
            if playerObj.inPlay.contains(card) {
                action.name = .stealInPlay
            }

        default:
            return
        }
    }
}
