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
                    .id(action.payload.played),
                    from: .playerHand(action.payload.player),
                    to: .discard
                )

        case .equip:
                .moveCard(
                    .id(action.payload.played),
                    from: .playerHand(action.payload.player),
                    to: .playerInPlay(action.payload.player)
                )

        case .handicap:
                .moveCard(
                    .id(action.payload.played),
                    from: .playerHand(action.payload.player),
                    to: .playerInPlay(action.payload.target!)
                )

        case .drawDeck:
                .moveCard(
                    .hidden,
                    from: .deck,
                    to: .playerHand(action.payload.target!)
                )

        case .drawDiscovered:
                .moveCard(
                    .id(action.payload.card!),
                    from: .deck,
                    to: .playerHand(action.payload.target!)
                )

        case .drawDiscard:
                .moveCard(
                    .hidden,
                    from: .discard,
                    to: .playerHand(action.payload.target!)
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
                    from: .playerHand(action.payload.target!),
                    to: .playerHand(action.payload.player)
                )

        case .stealInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.target!),
                    to: .playerHand(action.payload.player)
                )

        case .passInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.player),
                    to: .playerInPlay(action.payload.target!)
                )

        case .discardHand:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerHand(action.payload.target!),
                    to: .discard
                )

        case .discardInPlay:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerInPlay(action.payload.target!),
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
