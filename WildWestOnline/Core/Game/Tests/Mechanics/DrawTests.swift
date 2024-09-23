//
//  DrawTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import GameCore
import Testing

struct DrawTests {
    @Test func draw_shouldMoveCardFromDeckToDiscard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c2", "c3"])
            .withDiscard(["c1"])
            .build()

        // When
        let action = GameAction.draw
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.discard == ["c2", "c1"])
        #expect(result.field.deck == ["c3"])
    }
}
