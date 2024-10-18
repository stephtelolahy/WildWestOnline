//
//  BarrelTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct BarrelTests {
    /*
    @Test func playingBarrel_shouldEquip() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.barrel])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.barrel, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.barrel, player: "p1")
        ])
    }

    @Test func triggeringBarrel_oneFlippedCard_isHearts_shouldCancelShot() async throws {
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
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw
        ])
    }

    @Test func triggeringBarrel_oneFlippedCard_isSpades_shouldApplyDamage() async throws {
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
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw,
            .damage(1, player: "p2")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCards_oneIsHearts_shouldCancelShot() async throws {
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
        let result = try await dispatch(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw,
            .draw
        ])
    }

    @Test func triggeringBarrel_twoFlippedCards_noneIsHearts_shouldApplyDamage() async throws {
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
        let result = try await dispatch(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw,
            .draw,
            .damage(1, player: "p2")
        ])
    }

    @Test func triggeringBarrel_flippedCardIsHearts_holdingMissedCards_shouldNotAskToCounter() async throws {
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
        let result = try await dispatch(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw
        ])
    }
     */
}
