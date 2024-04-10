//
//  AnimationEventMatcher.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 04/04/2024.
//

import GameCore

protocol AnimationEventMatcherProtocol {
    func animation(on event: GameAction) -> EventAnimation?
}

struct EventAnimation: Equatable {
    let type: EventAnimationType
    let duration: TimeInterval
}

enum EventAnimationType: Equatable {
    case move(card: String?, source: CardArea, target: CardArea)
    case reveal(card: String?, source: CardArea, target: CardArea)
    case dummy
}

enum CardArea: Hashable, Equatable {
    case deck
    case discard
    case store
    case hand(String)
    case inPlay(String)
}

enum StateCard {
    static let deck = "deck"
    static let discard = "discard"
}

class AnimationEventMatcher: AnimationEventMatcherProtocol {

    private let preferences: UserPreferencesProtocol

    init(preferences: UserPreferencesProtocol) {
        self.preferences = preferences
    }

    func waitDuration(_ event: GEvent) -> Double {
        guard let animation = animation(on: event) else {
            return 0
        }

        return animation.duration
    }

    func animation(on event: GEvent) -> EventAnimation? {
        guard let type = animationType(on: event) else {
            return nil
        }

        return EventAnimation(type: type, duration: preferences.updateDelay)
    }

    private func animationType(on event: GEvent) -> EventAnimationType? {
        switch event {
        case .setTurn,
        .setPhase,
        .gainHealth,
        .looseHealth,
        .eliminate,
        .addHit:
            return .dummy

        case let .drawDeck(player):
            return .move(card: nil, source: .deck, target: .hand(player))

        case let .drawDeckChoosing(player, _):
            return .move(card: nil, source: .deck, target: .hand(player))

        case let .drawDeckFlipping(player):
            return .reveal(card: StateCard.deck, source: .deck, target: .hand(player))

        case let .drawHand(player, other, _):
            return .move(card: nil, source: .hand(other), target: .hand(player))

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

        default:
            return nil
        }
    }
}
