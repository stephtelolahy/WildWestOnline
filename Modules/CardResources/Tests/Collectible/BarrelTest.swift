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
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(1)
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2"),
            .draw(),
            .counterShoot(player: "p2")
        ])
    }

    @Test func triggeringBarrel_oneFlippedCardIsSpades_shouldNotCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(1)
            }
            .withDeck(["c1-A♠️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2"),
            .draw(),
            .damage(1, player: "p2")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsWithFirstIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(2)
            }
            .withDeck(["c1-2♥️", "c1-A♠️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2"),
            .draw(),
            .draw(),
            .counterShoot(player: "p2")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsWithSecondIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(2)
            }
            .withDeck(["c1-A♠️", "c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2"),
            .draw(),
            .draw(),
            .counterShoot(player: "p2")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsNoneIsHearts_shouldNotCancelShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(2)
            }
            .withDeck(["c1-A♠️", "c1-2♠️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2"),
            .draw(),
            .draw(),
            .damage(1, player: "p2")
        ])
    }

    @Test func triggeringBarrel_flippedCardIsHearts_holdingMissedCards_shouldNotAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withInPlay([.barrel])
                    .withDrawCards(1)
                    .withAbilities([.discardCounterCardOnShot])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2"),
            .draw(),
            .counterShoot(player: "p2")
        ])
    }
}
