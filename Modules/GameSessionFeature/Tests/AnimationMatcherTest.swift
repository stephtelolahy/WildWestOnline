//
//  AnimationMatcherTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/03/2025.
//

import Testing
import GameCore
@testable import GameSessionFeature

struct AnimationMatcherTest {
    private let sut = AnimationMatcher()

    @Test(arguments: [
        (.play("c1", player: "p1"), .moveCard(.id("c1"), from: .playerHand("p1"), to: .discard)),
        (.equip("c1", player: "p1"), .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerInPlay("p1"))),
        (.handicap("c1", target: "p2", player: "p1"), .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerInPlay("p2"))),
        (.drawDeck(player: "p1"), .moveCard(.hidden, from: .deck, to: .playerHand("p1"))),
        // TODO: card id = top discard
        (.draw(player: "p1"), .moveCard(.hidden, from: .deck, to: .discard)),
        (.stealHand("c1", target: "p2", player: "p1"), .moveCard(.hidden, from: .playerHand("p2"), to: .playerHand("p1"))),
        (.stealInPlay("c1", target: "p2", player: "p1"), .moveCard(.id("c1"), from: .playerInPlay("p2"), to: .playerHand("p1"))),
        (.drawDiscovered("c1", player: "p1"), .moveCard(.id("c1"), from: .deck, to: .playerHand("p1"))),
        (.drawDiscard("c1", player: "p1"), .moveCard(.id("c1"), from: .discard, to: .playerHand("p1"))),
        (.passInPlay("c1", target: "p2", player: "p1"), .moveCard(.id("c1"), from: .playerInPlay("p1"), to: .playerInPlay("p2"))),
        (.discardHand("c1", player: "p1"), .moveCard(.id("c1"), from: .playerHand("p1"), to: .discard)),
        (.discardInPlay("c1", player: "p1"), .moveCard(.id("c1"), from: .playerInPlay("p1"), to: .discard)),
        // TODO: card id = last discovered
        (.discover(), .moveCard(.hidden, from: .deck, to: .discovered)),
        (.showHand("c1", player: "p1"), .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerHand("p1")))
    ] as [(GameFeature.Action, BoardAnimation)])
    func animationOnEvent(event: GameFeature.Action, expected: BoardAnimation) {
        #expect(sut.animation(on: event) == expected)
    }
}
