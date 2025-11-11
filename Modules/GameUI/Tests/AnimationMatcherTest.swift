//
//  AnimationMatcherTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/03/2025.
//

import Testing
@testable import GameUI
import GameFeature

struct AnimationMatcherTest {
    private let sut = AnimationMatcher()

    @Test func animatePlay() async throws {
        // Given
        let event = GameFeature.Action.play("c1", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .discard))
    }

    @Test func animateEquip() async throws {
        // Given
        let event = GameFeature.Action.equip("c1", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerInPlay("p1")))
    }

    @Test func animateHandicap() async throws {
        // Given
        let event = GameFeature.Action.handicap("c1", target: "p2", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerInPlay("p2")))
    }

    @Test func animateDrawDeck() async throws {
        // Given
        let event = GameFeature.Action.drawDeck(player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.hidden, from: .deck, to: .playerHand("p1")))
    }

    @Test func animateDraw() async throws {
        // Given
        let event = GameFeature.Action.draw()

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        // TODO: card id = top discard
        #expect(animation == .moveCard(.hidden, from: .deck, to: .discard))
    }

    @Test func animateStealHand() async throws {
        // Given
        let event = GameFeature.Action.stealHand("c1", target: "p2", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.hidden, from: .playerHand("p2"), to: .playerHand("p1")))
    }

    @Test func animateStealInPlay() async throws {
        // Given
        let event = GameFeature.Action.stealInPlay("c1", target: "p2", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerInPlay("p2"), to: .playerHand("p1")))
    }

    @Test func animateDrawDiscovered() async throws {
        // Given
        let event = GameFeature.Action.drawDiscovered("c1", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .deck, to: .playerHand("p1")))
    }

    @Test func animateDrawDiscard() async throws {
        // Given
        let event = GameFeature.Action.drawDiscard(player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        // TODO: card id = last hand
        #expect(animation == .moveCard(.hidden, from: .discard, to: .playerHand("p1")))
    }

    @Test func animatePassInPlay() async throws {
        // Given
        let event = GameFeature.Action.passInPlay("c1", target: "p2", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerInPlay("p1"), to: .playerInPlay("p2")))
    }

    @Test func animateDiscardHand() async throws {
        // Given
        let event = GameFeature.Action.discardHand("c1", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .discard))
    }

    @Test func animateDiscardInPlay() async throws {
        // Given
        let event = GameFeature.Action.discardInPlay("c1", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerInPlay("p1"), to: .discard))
    }

    @Test func animateDiscover() async throws {
        // Given
        let event = GameFeature.Action.discover()

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        // TODO: card id = last discovered
        #expect(animation == .moveCard(.hidden, from: .deck, to: .discovered))
    }

    @Test func animateShowHand() async throws {
        // Given
        let event = GameFeature.Action.showHand("c1", player: "p1")

        // When
        let animation = try #require(sut.animation(on: event))

        // Then
        #expect(animation == .moveCard(.id("c1"), from: .playerHand("p1"), to: .playerHand("p1")))
    }
}
