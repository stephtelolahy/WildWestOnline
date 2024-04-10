//
//  AnimationMatcher.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 04/04/2024.
//
// swiftlint:disable identifier_name type_contents_order

import Foundation
import GameCore

protocol AnimationMatcherProtocol {
    func animation(on event: GameAction) -> EventAnimation?
}

struct EventAnimation: Equatable {
    let type: AnimationType
    let duration: TimeInterval

    enum AnimationType: Equatable {
        case move(card: String?, from: CardArea, to: CardArea)
        case reveal(card: String?, from: CardArea, to: CardArea)
    }

    enum CardArea: Hashable, Equatable {
        case deck
        case discard
        case arena
        case hand(String)
        case inPlay(String)
    }

    enum CardId {
        static let deck = "deck"
        static let discard = "discard"
    }
}

struct AnimationMatcher: AnimationMatcherProtocol {
    func animation(on event: GameAction) -> EventAnimation? {
        guard let type = animationType(on: event) else {
            return nil
        }

        return EventAnimation(type: type, duration: 0.5)
    }
}

private extension AnimationMatcher {
    func waitDuration(_ event: GameAction) -> Double {
        guard let animation = animation(on: event) else {
            return 0
        }

        return animation.duration
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func animationType(on event: GameAction) -> EventAnimation.AnimationType? {
        switch event {
        case let .drawDeck(player):
            return .move(card: nil, from: .deck, to: .hand(player))

        case let .putBack(_, player):
            return .move(card: nil, from: .hand(player), to: .deck)

        case let .revealHand(card, player):
            return .reveal(card: card, from: .hand(player), to: .hand(player))

        case let .drawHand(_, target, player):
            return .move(card: nil, from: .hand(target), to: .hand(player))
/*
        case let .drawInPlay(player, other, card):
            return .move(card: card, source: .inPlay(other), target: .hand(player))

        case let .drawStore(player, card):
            return .move(card: card, source: .store, target: .hand(player))

        case let .drawDiscard(player):
            return .move(card: StateCard.discard, source: .discard, target: .hand(player))

        case let .equip(player, card):
            return .move(card: card, source: .hand(player), target: .inPlay(player))

        case let .handicap(player, card, other):
            return .move(card: card, source: .hand(player), target: .inPlay(other))

        case let .passInPlay(player, card, other):
            return .move(card: card, source: .inPlay(player), target: .inPlay(other))

        case let .discardHand(player, card):
            return .move(card: card, source: .hand(player), target: .discard)

        case let .play(player, card):
            return .move(card: card, source: .hand(player), target: .discard)

        case let .discardInPlay(player, card):
            return .move(card: card, source: .inPlay(player), target: .discard)

        case .deckToStore:
            return .reveal(card: StateCard.deck, source: .deck, target: .store)

        case .flipDeck:
            return .reveal(card: StateCard.deck, source: .deck, target: .discard)
*/
        default:
            fatalError("undefined")
        }
    }
}
