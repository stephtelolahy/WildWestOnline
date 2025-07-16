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
                    .id(action.payload.playedCard),
                    from: .playerHand(action.payload.player),
                    to: .discard
                )

        case .equip:
                .moveCard(
                    .id(action.payload.playedCard),
                    from: .playerHand(action.payload.player),
                    to: .playerInPlay(action.payload.player)
                )

        case .handicap:
                .moveCard(
                    .id(action.payload.playedCard),
                    from: .playerHand(action.payload.player),
                    to: .playerInPlay(action.payload.targetedPlayer!)
                )

        case .drawDeck:
                .moveCard(
                    .hidden,
                    from: .deck,
                    to: .playerHand(action.payload.targetedPlayer!)
                )

        case .drawDiscovered:
                .moveCard(
                    .id(action.payload.card!),
                    from: .deck,
                    to: .playerHand(action.payload.targetedPlayer!)
                )

        case .drawDiscard:
                .moveCard(
                    .hidden,
                    from: .discard,
                    to: .playerHand(action.payload.targetedPlayer!)
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
                    from: .playerHand(action.payload.targetedPlayer!),
                    to: .playerHand(action.payload.player)
                )

        case .stealInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.targetedPlayer!),
                    to: .playerHand(action.payload.player)
                )

        case .passInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.player),
                    to: .playerInPlay(action.payload.targetedPlayer!)
                )

        case .discardHand:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerHand(action.payload.targetedPlayer!),
                    to: .discard
                )

        case .discardInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.targetedPlayer!),
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
