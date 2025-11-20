//
//  BarrelTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct BarrelTest {
    @Test func playingBarrel_shouldEquip() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.barrel])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.barrel, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.barrel, player: "p1")
        ])
    }

    @Test func triggeringBarrel_oneFlippedCardIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.barrel])
                    .withCardsPerDraw(1)
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .counterShoot(player: "p1")
        ])
    }

    @Test func triggeringBarrel_oneFlippedCardIsSpades_shouldNotCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.barrel])
                    .withCardsPerDraw(1)
            }
            .withDeck(["c1-A♠️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .damage(1, player: "p1")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsWithFirstIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.barrel])
                    .withCardsPerDraw(2)
            }
            .withDeck(["c1-2♥️", "c1-A♠️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .draw(),
            .counterShoot(player: "p1")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsWithSecondIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.barrel])
                    .withCardsPerDraw(2)
            }
            .withDeck(["c1-A♠️", "c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .draw(),
            .counterShoot(player: "p1")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsNoneIsHearts_shouldNotCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.barrel])
                    .withCardsPerDraw(2)
            }
            .withDeck(["c1-A♠️", "c1-2♠️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .draw(),
            .damage(1, player: "p1")
        ])
    }

    @Test func triggeringBarrel_flippedCardIsHearts_holdingMissedCards_shouldNotAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand([.missed])
                    .withInPlay([.barrel])
                    .withCardsPerDraw(1)
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .counterShoot(player: "p1")
        ])
    }
}
