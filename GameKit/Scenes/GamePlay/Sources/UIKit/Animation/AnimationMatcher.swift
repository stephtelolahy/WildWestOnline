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
        case move(card: String?, from: CardLocation, to: CardLocation)
        case reveal(card: String?, from: CardLocation, to: CardLocation)
    }

    enum CardLocation: Hashable, Equatable {
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
    let animationDelay: TimeInterval

    func animation(on event: GameAction) -> EventAnimation? {
        guard let type = animationType(on: event) else {
            return nil
        }

        return EventAnimation(type: type, duration: animationDelay)
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

        case let .drawInPlay(card, target, player):
            return .move(card: card, from: .inPlay(target), to: .hand(player))

        case let .drawArena(card, player):
            return .move(card: card, from: .arena, to: .hand(player))

        case let .drawDiscard(player):
            return .move(card: .topDiscardCard, from: .discard, to: .hand(player))

        case let .equip(card, player):
            return .move(card: card, from: .hand(player), to: .inPlay(player))

        case let .handicap(card, target, player):
            return .move(card: card, from: .hand(player), to: .inPlay(target))

        case let .passInPlay(card, target, player):
            return .move(card: card, from: .inPlay(player), to: .inPlay(target))

        case let .discardHand(card, player):
            return .move(card: card, from: .hand(player), to: .discard)

        case .play:
            return nil

        case let .discardInPlay(card, player):
            return .move(card: card, from: .inPlay(player), to: .discard)

        case .discover:
            return .reveal(card: .topDeckCard, from: .deck, to: .arena)

        case .draw:
            return .reveal(card: .topDeckCard, from: .deck, to: .discard)

        case .heal:
            return nil

        case .damage:
            return nil

        case let .discardPlayed(card, player):
            return .move(card: card, from: .hand(player), to: .discard)

        case .setTurn:
            return nil

        case .eliminate:
            return nil

        case .setAttribute:
            return nil

        case .removeAttribute:
            return nil

        case .cancel:
            return nil

        case .chooseOne:
            return nil

        case .choose:
            return nil

        case .activate:
            return nil

        case .setGameOver:
            return nil

        case .effect:
            return nil

        case .group:
            return nil
        }
    }
}
