//
//  TriggerMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 26/07/2025.
//
extension Card.Trigger {
    func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
        let name = action.name
        let isSource = action.sourcePlayer == player
        let isTarget = action.targetedPlayer == player
        let parent = action.triggeredBy.first

        switch self {
        case .permanent, .prePlayed, .played:
            return false

        case .equiped:
            return name == .equip && isSource && action.sourceCard == card

        case .discarded:
            return [.discardInPlay, .stealInPlay].contains(name) && isTarget && action.targetedCard == card

        case .damaged:
            return name == .damage && isTarget && state.players.get(player).health > 0

        case .lethallyDamaged:
            return name == .damage && isTarget && state.players.get(player).health <= 0

        case .eliminated:
            return name == .eliminate && isTarget

        case .handEmptied:
            let emptiedByTarget = [.discardHand, .stealHand].contains(name) && isTarget
            let emptiedBySource = [.play, .equip].contains(name) && isSource
            return (emptiedByTarget || emptiedBySource) && state.players.get(player).hand.isEmpty

        case .turnStarted:
            return name == .startTurn && isTarget

        case .turnEnded:
            return name == .endTurn && isTarget

        case .shot:
            return name == .shoot && isTarget

        case .eliminatingOther:
            return name == .eliminate
            && parent?.name == .damage
            && parent?.sourcePlayer == player
            && parent?.targetedPlayer != player

        case .otherEliminated:
            return name == .eliminate && !isTarget

        case .drawLastCardOnTurnStarted:
            return name == .drawDeck && isTarget && state.queue.isEmpty && parent?.name == .startTurn

        case .weaponPrePlayed:
            return name == .preparePlay
            && isSource
            && state.cards.get(Card.name(of: action.sourceCard)).effects.contains { $0.action == .setWeapon }

        case .shootingWithCard(let cardName):
            guard let parent else {
                return false
            }

            return name == .shoot && isSource && parent.name == .play && Card.name(of: parent.sourceCard) == cardName

        case .prePlayingCard(let cardName):
            return name == .preparePlay && Card.name(of: action.sourceCard) == cardName

        case .drawRequired:
            let isFollowingDraw = state.events.count > 1 && state.events[1].name == .draw
            return name == .draw && isTarget && !isFollowingDraw

        case .hasStealHandOnTurnStarted:
            return name == .stealHand && isSource && parent?.name == .startTurn

        case .hasDrawDiscardOnTurnStarted:
            return name == .drawDiscard && isTarget && parent?.name == .startTurn
        }
    }
}
