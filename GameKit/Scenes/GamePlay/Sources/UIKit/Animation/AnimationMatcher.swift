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
    case move(card: String?, from: Location, to: Location)
    case reveal(card: String?, from: Location, to: Location)

    enum Location: Hashable, Equatable {
        case deck
        case discard
        case arena
        case hand(String)
        case inPlay(String)
    }
}

extension String {
    static let topDeckCard = "$deck"
    static let topDiscardCard = "$discard"
}

struct AnimationMatcher: AnimationMatcherProtocol {
    // swiftlint:disable:next cyclomatic_complexity
    func animation(on event: GameAction) -> EventAnimation? {
        switch event {
        case let .drawDeck(player):
                .move(card: nil, from: .deck, to: .hand(player))

        case let .putBack(_, player):
                .move(card: nil, from: .hand(player), to: .deck)

        case let .revealHand(card, player):
                .reveal(card: card, from: .hand(player), to: .hand(player))

        case let .drawHand(_, target, player):
                .move(card: nil, from: .hand(target), to: .hand(player))

        case let .drawInPlay(card, target, player):
                .move(card: card, from: .inPlay(target), to: .hand(player))

        case let .drawArena(card, player):
                .move(card: card, from: .arena, to: .hand(player))

        case let .drawDiscard(player):
                .move(card: .topDiscardCard, from: .discard, to: .hand(player))

        case let .equip(card, player):
                .move(card: card, from: .hand(player), to: .inPlay(player))

        case let .handicap(card, target, player):
                .move(card: card, from: .hand(player), to: .inPlay(target))

        case let .passInPlay(card, target, player):
                .move(card: card, from: .inPlay(player), to: .inPlay(target))

        case let .discardHand(card, player):
                .move(card: card, from: .hand(player), to: .discard)

        case .play:
            nil

        case let .discardInPlay(card, player):
                .move(card: card, from: .inPlay(player), to: .discard)

        case .discover:
                .reveal(card: .topDeckCard, from: .deck, to: .arena)

        case .draw:
                .reveal(card: .topDeckCard, from: .deck, to: .discard)

        case .heal:
            nil

        case .damage:
            nil

        case let .discardPlayed(card, player):
                .move(card: card, from: .hand(player), to: .discard)

        case .setTurn:
            nil

        case .eliminate:
            nil

        case .setAttribute:
            nil

        case .removeAttribute:
            nil

        case .cancel:
            nil

        case .chooseOne:
            nil

        case .choose:
            nil

        case .activate:
            nil

        case .setGameOver:
            nil

        case .effect:
            nil

        case .group:
            nil
        }
    }
}
