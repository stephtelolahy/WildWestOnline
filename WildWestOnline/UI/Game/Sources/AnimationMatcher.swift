//
//  AnimationMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/03/2025.
//
import GameCore

struct AnimationMatcher {
    func animation(on action: GameAction) -> AnimationKind? {
        switch action.kind {
        case .play:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerHand(action.payload.target),
                    to: .discard
                )

        case .equip:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerHand(action.payload.target),
                    to: .playerInPlay(action.payload.target)
                )

        case .handicap:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerHand(action.payload.actor),
                    to: .playerInPlay(action.payload.target)
                )

        case .drawDeck:
                .moveCard(
                    .hidden,
                    from: .deck,
                    to: .playerHand(action.payload.target)
                )

        case .drawDiscovered:
                .moveCard(
                    .id(action.payload.card!),
                    from: .deck,
                    to: .playerHand(action.payload.target)
                )

        case .drawDiscard:
                .moveCard(
                    .hidden,
                    from: .discard,
                    to: .playerHand(action.payload.target)
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
                    from: .playerHand(action.payload.target),
                    to: .playerHand(action.payload.actor)
                )

        case .stealInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.target),
                    to: .playerHand(action.payload.actor)
                )

        case .passInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.actor),
                    to: .playerInPlay(action.payload.target)
                )

        case .discardHand:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerHand(action.payload.target),
                    to: .discard
                )

        case .discardInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.target),
                    to: .discard
                )

        case .discover:
                .moveCard(
                    .hidden,
                    from: .deck,
                    to: .deck
                )

        default:
            nil
        }
    }
}

enum AnimationKind: Equatable {
    case moveCard(CardContent, from: ViewPosition, to: ViewPosition)
}

enum ViewPosition: Hashable {
    case deck
    case discard
    case playerHand(String)
    case playerInPlay(String)
}

enum CardContent: Equatable {
    case id(String)
    case hidden
}
