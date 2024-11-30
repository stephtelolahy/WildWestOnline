//
//  DrawDiscardTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import Bang

struct DrawDiscardTest {
    @Test func drawDiscard_whithNonEmptyDiscard_shouldRemoveTopCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDiscard(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c1"])
        #expect(result.discard == ["c2"])
    }

    @Test func drawDiscard_whitEmptyDiscard_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        // Then
        let action = GameAction.drawDiscard(player: "p1")
        #expect(throws: GameError.insufficientDiscard) {
            try GameReducer().reduce(state, action)
        }
    }
}
