//
//  BarrelTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class BarrelTests: XCTestCase {
    func test_playingBarrel_shouldEquip() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.barrel])
            }
            .build()

        // When
        let action = GameAction.play(.barrel, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.barrel, player: "p1"),
            .equip(.barrel, player: "p1")
        ])
    }

    func test_triggeringBarrel_oneFlippedCard_isHearts_shouldCancelShot() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .missesRequiredForBang: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withAttributes([.flippedCards: 1])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .draw
        ])
    }

    func test_triggeringBarrel_oneFlippedCard_isSpades_shouldApplyDamage() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withAttributes([.flippedCards: 1])
            }
            .withDeck(["c1-A♠️"])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .draw,
            .damage(1, player: "p2")
        ])
    }

    func test_triggeringBarrel_twoFlippedCards_oneIsHearts_shouldCancelShot() {
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
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .draw,
            .draw
        ])
    }

    func test_triggeringBarrel_twoFlippedCards_noneIsHearts_shouldApplyDamage() {
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
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .draw,
            .draw,
            .damage(1, player: "p2")
        ])
    }

    func test_triggeringBarrel_flippedCardIsHearts_holdingMissedCards_shouldNotAskToCounter() {
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
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .draw
        ])
    }
}
