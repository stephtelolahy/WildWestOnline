//
//  DrawDeckTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import Bang

struct DrawDeckTest {
    @Test func drawDeck_whithNonEmptyDeck_shouldRemoveTopCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDeck(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c1"])
        #expect(result.deck == ["c2"])
    }

    @Test func drawDeck_whitEmptyDeckAndEnoughDiscardPile_shouldResetDeck() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2", "c3", "c4"])
            .build()

        // When
        let action = GameAction.drawDeck(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.deck == ["c3", "c4"])
        #expect(result.discard == ["c1"])
        #expect(result.players.get("p1").hand == ["c2"])
    }

    @Test func drawDeck_whitEmptyDeckAndNotEnoughDiscardPile_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        // Then
        let action = GameAction.drawDeck(player: "p1")
        #expect(throws: GameError.insufficientDeck) {
            try GameReducer().reduce(state, action)
        }
    }
}
