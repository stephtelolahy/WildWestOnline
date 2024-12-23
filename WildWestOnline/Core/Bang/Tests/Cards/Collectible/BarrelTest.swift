//
//  BarrelTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

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

    @Test func triggeringBarrel_oneFlippedCardIsSpades_shouldApplyDamage() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
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
/*
    func test_triggeringBarrel_twoFlippedCards_oneIsHearts_shouldCancelShot() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .missesRequiredForBang: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withAttributes([.flippedCards: 2])
            }
            .withDeck(["c1-A♠️", "c1-2♥️"])
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw,
            .draw
        ])
    }

    func test_triggeringBarrel_twoFlippedCards_noneIsHearts_shouldApplyDamage() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withAttributes([.flippedCards: 2])
            }
            .withDeck(["c1-A♠️", "c1-2♠️"])
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw,
            .draw,
            .damage(1, player: "p2")
        ])
    }

    func test_triggeringBarrel_flippedCardIsHearts_holdingMissedCards_shouldNotAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .missesRequiredForBang: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withInPlay([.barrel])
                    .withAbilities([.playCounterCardsOnShot])
                    .withAttributes([.flippedCards: 1])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw
        ])
    }
 */
}
