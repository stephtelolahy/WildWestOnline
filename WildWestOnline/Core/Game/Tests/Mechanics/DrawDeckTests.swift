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
        #expect(result.player("p1").hand == ["c1"])
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
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.deck == ["c3", "c4"])
        #expect(result.discard == ["c1"])
        #expect(result.player("p1").hand == ["c2"])
    }

    @Test func drawDeck_whitEmptyDeckAndNotEnoughDiscardPile_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        // Then
        let action = GameAction.drawDeck(player: "p1")
        #expect(throws: GameState.Error.deckIsEmpty) {
            try GameState.reducer(state, action)
        }
    }
}
