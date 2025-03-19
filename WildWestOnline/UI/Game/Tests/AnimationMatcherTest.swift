//
//  AnimationMatcherTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/03/2025.
//

import Testing
@testable import GameUI
import GameCore

struct AnimationMatcherTest {

    private let sut = AnimationMatcher()

    @Test func animateDiscardPlayed() async throws {
        // Given
        let event = GameAction.discardPlayed("c1", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .discard))
    }

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
