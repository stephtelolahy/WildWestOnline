//
//  BarrelTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct BarrelTest {
    @Test func playingBarrel_shouldEquip() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.barrel])
            }
            .build()

        // When
        let action = GameAction.play(.barrel, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.barrel, player: "p1"),
            .equip(.barrel, player: "p1")
        ])
    }

    @Test func triggeringBarrel_oneFlippedCardIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(1)
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameAction.shoot("p2", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2", player: "p1"),
            .draw(player: "p2"),
            .counterShoot(player: "p2")
        ])
    }

    @Test func triggeringBarrel_oneFlippedCardIsSpades_shouldNotCancelShot() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(1)
            }
            .withDeck(["c1-A♠️"])
            .build()

        // When
        let action = GameAction.shoot("p2", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2", player: "p1"),
            .draw(player: "p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsWithFirstIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(2)
            }
            .withDeck(["c1-2♥️", "c1-A♠️"])
            .build()

        // When
        let action = GameAction.shoot("p2", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2", player: "p1"),
            .draw(player: "p2"),
            .draw(player: "p2"),
            .counterShoot(player: "p2")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsWithSecondIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(2)
            }
            .withDeck(["c1-A♠️", "c1-2♥️"])
            .build()

        // When
        let action = GameAction.shoot("p2", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2", player: "p1"),
            .draw(player: "p2"),
            .draw(player: "p2"),
            .counterShoot(player: "p2")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsNoneIsHearts_shouldNotCancelShot() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withDrawCards(2)
            }
            .withDeck(["c1-A♠️", "c1-2♠️"])
            .build()

        // When
        let action = GameAction.shoot("p2", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2", player: "p1"),
            .draw(player: "p2"),
            .draw(player: "p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func triggeringBarrel_flippedCardIsHearts_holdingMissedCards_shouldNotAskToCounter() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withInPlay([.barrel])
                    .withDrawCards(1)
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameAction.shoot("p2", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p2", player: "p1"),
            .draw(player: "p2"),
            .counterShoot(player: "p2")
        ])
    }
}
