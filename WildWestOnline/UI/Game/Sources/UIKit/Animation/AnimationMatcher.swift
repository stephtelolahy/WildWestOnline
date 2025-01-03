//
//  AnimationMatcher.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 04/04/2024.
//
// swiftlint:disable identifier_name

import Foundation
import GameCore

protocol AnimationMatcherProtocol {
    func animation(on event: GameAction) -> EventAnimation?
}

enum EventAnimation: Equatable {
    case move(card: Card, from: Location, to: Location)
    case reveal(card: Card, from: Location, to: Location)

    enum Card: Equatable {
        case id(String)
        case topDeck
        case topDiscard
        case hidden
    }

    enum Location: Hashable, Equatable {
        case deck
        case discard
        case arena
        case hand(String)
        case inPlay(String)
    }
}

struct AnimationMatcher: AnimationMatcherProtocol {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func animation(on event: GameAction) -> EventAnimation? {
        nil
        // TODO: Convert action to animation
        /*
        switch event {
        case let .playBrown(card, player):
                .move(card: .id(card), from: .hand(player), to: .discard)

        case let .playEquipment(card, player):
                .move(card: .id(card), from: .hand(player), to: .inPlay(player))

        case let .playHandicap(card, target, player):
                .move(card: .id(card), from: .hand(player), to: .inPlay(target))

        case let .drawDeck(player):
                .move(card: .hidden, from: .deck, to: .hand(player))

        case let .putBack(_, player):
                .move(card: .hidden, from: .hand(player), to: .deck)

        case let .showHand(card, player):
                .reveal(card: .id(card), from: .hand(player), to: .hand(player))

        case let .stealHand(_, target, player):
                .move(card: .hidden, from: .hand(target), to: .hand(player))

        case let .stealInPlay(card, target, player):
                .move(card: .id(card), from: .inPlay(target), to: .hand(player))

        case let .drawArena(card, player):
                .move(card: .id(card), from: .arena, to: .hand(player))

        case let .drawDiscard(player):
                .move(card: .topDiscard, from: .discard, to: .hand(player))

        case let .passInPlay(card, target, player):
                .move(card: .id(card), from: .inPlay(player), to: .inPlay(target))

        case let .discardHand(card, player):
                .move(card: .id(card), from: .hand(player), to: .discard)

        case let .discardInPlay(card, player):
                .move(card: .id(card), from: .inPlay(player), to: .discard)

        case .discover:
                .reveal(card: .topDeck, from: .deck, to: .arena)

        case .draw:
                .reveal(card: .topDeck, from: .deck, to: .discard)

        default:
            nil
        }
         */
    }
}
