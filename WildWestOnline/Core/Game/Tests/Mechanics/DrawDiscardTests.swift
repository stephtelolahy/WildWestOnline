//
//  DrawDiscardTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

import GameCore
import Testing

struct DrawDiscardTests {
    @Test func drawDiscard_whithNonEmptyDiscard_shouldRemoveTopCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDiscard(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").hand == ["c1"])
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
        #expect(throws: GameState.Error.discardIsEmpty) {
            try GameState.reducer(state, action)
        }
    }
}
