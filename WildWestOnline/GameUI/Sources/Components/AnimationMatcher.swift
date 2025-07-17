//
//  AnimationMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/03/2025.
//
import GameCore

struct AnimationMatcher {
    func animation(on action: GameFeature.Action) -> BoardAnimation? {
        switch action.name {
        case .play:
                .moveCard(
                    .id(action.playedCard),
                    from: .playerHand(action.player),
                    to: .discard
                )

        case .equip:
                .moveCard(
                    .id(action.playedCard),
                    from: .playerHand(action.player),
                    to: .playerInPlay(action.player)
                )

        case .handicap:
                .moveCard(
                    .id(action.playedCard),
                    from: .playerHand(action.player),
                    to: .playerInPlay(action.targetedPlayer!)
                )

        case .drawDeck:
                .moveCard(
                    .hidden,
                    from: .deck,
                    to: .playerHand(action.targetedPlayer!)
                )

        case .drawDiscovered:
                .moveCard(
                    .id(action.targetedCard!),
                    from: .deck,
                    to: .playerHand(action.targetedPlayer!)
                )

        case .drawDiscard:
                .moveCard(
                    .hidden,
                    from: .discard,
                    to: .playerHand(action.targetedPlayer!)
                )

        case .draw:
                .moveCard(
                    .hidden,
                    from: .deck,
                    to: .discard
                )

        case .stealHand:
                .moveCard(
                    .hidden,
                    from: .playerHand(action.targetedPlayer!),
                    to: .playerHand(action.player)
                )

        case .stealInPlay:
                .moveCard(
                    .id(action.targetedCard!),
                    from: .playerInPlay(action.targetedPlayer!),
                    to: .playerHand(action.player)
                )

        case .passInPlay:
                .moveCard(
                    .id(action.targetedCard!),
                    from: .playerInPlay(action.player),
                    to: .playerInPlay(action.targetedPlayer!)
                )

        case .discardHand:
                .moveCard(
                    .id(action.targetedCard!),
                    from: .playerHand(action.targetedPlayer!),
                    to: .discard
                )

        case .discardInPlay:
                .moveCard(
                    .id(action.targetedCard!),
                    from: .playerInPlay(action.targetedPlayer!),
                    to: .discard
                )

        case .discover:
                .moveCard(
                    .hidden,
                    from: .deck,
                    to: .discovered
                )

        default:
            nil
        }
    }
}

enum BoardAnimation: Equatable {
    case moveCard(CardContent, from: ViewPosition, to: ViewPosition)
}
