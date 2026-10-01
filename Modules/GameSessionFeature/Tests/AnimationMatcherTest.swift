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

    @Test func animatePlay() async throws {
        let event = GameFeature.Action.play("c1", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .discard))
    }

    @Test func animateEquip() async throws {
        let event = GameFeature.Action.equip("c1", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerInPlay("p1")))
    }

    @Test func animateHandicap() async throws {
        let event = GameFeature.Action.handicap("c1", target: "p2", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerInPlay("p2")))
    }

    @Test func animateDrawDeck() async throws {
        let event = GameFeature.Action.drawDeck(player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.hidden, from: .deck, to: .playerHand("p1")))
    }

    @Test func animateDraw() async throws {
        let event = GameFeature.Action.draw(player: "p1")

        let animation = try #require(sut.animation(on: event))

        // TODO: card id = top discard
        #expect(animation == .moveCard(.hidden, from: .deck, to: .discard))
    }

    @Test func animateStealHand() async throws {
        let event = GameFeature.Action.stealHand("c1", target: "p2", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.hidden, from: .playerHand("p2"), to: .playerHand("p1")))
    }

    @Test func animateStealInPlay() async throws {
        let event = GameFeature.Action.stealInPlay("c1", target: "p2", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .playerInPlay("p2"), to: .playerHand("p1")))
    }

    @Test func animateDrawDiscovered() async throws {
        let event = GameFeature.Action.drawDiscovered("c1", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .deck, to: .playerHand("p1")))
    }

    @Test func animateDrawDiscard() async throws {
        let event = GameFeature.Action.drawDiscard("c1", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .discard, to: .playerHand("p1")))
    }

    @Test func animatePassInPlay() async throws {
        let event = GameFeature.Action.passInPlay("c1", target: "p2", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .playerInPlay("p1"), to: .playerInPlay("p2")))
    }

    @Test func animateDiscardHand() async throws {
        let event = GameFeature.Action.discardHand("c1", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .discard))
    }

    @Test func animateDiscardInPlay() async throws {
        let event = GameFeature.Action.discardInPlay("c1", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .playerInPlay("p1"), to: .discard))
    }

    @Test func animateDiscover() async throws {
        let event = GameFeature.Action.discover()

        let animation = try #require(sut.animation(on: event))

        // TODO: card id = last discovered
        #expect(animation == .moveCard(.hidden, from: .deck, to: .discovered))
    }

    @Test func animateShowHand() async throws {
        let event = GameFeature.Action.showHand("c1", player: "p1")

        let animation = try #require(sut.animation(on: event))

        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerHand("p1")))
    }
}
