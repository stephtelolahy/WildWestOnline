//
//  BarrelTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
// swiftlint:disable no_magic_numbers

import Game
import XCTest

final class BarrelTests: XCTestCase {
    func test_playingBarrel_shouldEquip() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.barrel])
            }
            .build()

        // When
        let action = GameAction.play(.barrel, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.barrel, player: "p1"),
            .equip(.barrel, player: "p1")
        ])
    }

    func test_triggeringBarrel_oneFlippedCard_isHearts_shouldCancelShot() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withAttributes([.flippedCards: 1])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .draw,
            .cancel(.damage(1, player: "p2"))
        ])
    }

    func test_triggeringBarrel_oneFlippedCard_isSpades_shouldApplyDamage() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .draw,
            .damage(1, player: "p2")
        ])
    }

    func test_triggeringBarrel_twoFlippedCards_oneIsHearts_shouldCancelShot() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withInPlay([.barrel])
                    .withAttributes([.flippedCards: 2])
            }
            .withDeck(["c1-A♠️", "c1-2♥️"])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .draw,
            .draw,
            .cancel(.damage(1, player: "p2"))
        ])
    }

    func test_triggeringBarrel_twoFlippedCards_noneIsHearts_shouldApplyDamage() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .draw,
            .draw,
            .damage(1, player: "p2")
        ])
    }

    func test_triggeringBarrel_holdingMissedCards_shouldNotAskToCounter() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withInPlay([.barrel])
                    .withAbilities([.activateCounterCardsOnShot])
                    .withAttributes([.flippedCards: 1])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .draw,
            .cancel(.damage(1, player: "p2"))
        ])
    }
}