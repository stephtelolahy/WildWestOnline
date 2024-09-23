//
//  DrawSpec.swift
//
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import GameCore
import Testing

struct DrawDeckTests {
    @Test func drawDeck_whithNonEmptyDeck_shouldRemoveTopCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDeck(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.hand["p1"] == ["c1"])
        #expect(result.field.deck == ["c2"])
    }

    @Test func drawDeck_whitEmptyDeckAndEnoughDiscardPile_shouldResetDeck() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2", "c3", "c4"])
            .build()

        // When
        let action = GameAction.drawDeck(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.deck == ["c3", "c4"])
        #expect(result.field.discard == ["c1"])
        #expect(result.field.hand["p1"] == ["c2"])
    }

    @Test func drawDeck_whitEmptyDeckAndNotEnoughDiscardPile_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        // Then
        let action = GameAction.drawDeck(player: "p1")
        #expect(throws: FieldState.Error.deckIsEmpty) {
            try GameState.reducer(state, action)
        }
    }
}
