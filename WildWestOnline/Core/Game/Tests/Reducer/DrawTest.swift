//
//  DrawTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore
import Combine

struct DrawTest {
    @Test func draw_shouldMoveCardFromDeckToDiscard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c2", "c3"])
            .withDiscard(["c1"])
            .build()

        // When
        let action = GameAction.draw()
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.discard == ["c2", "c1"])
        #expect(result.deck == ["c3"])
    }

    @Test func draw_withEmptyDeck_withEnoughDiscard_shouldResetDeck() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDiscard(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.draw()
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.discard == ["c2", "c1"])
        #expect(result.deck == ["c3"])
    }

    @Test func draw_withEmptyDeck_withoutEnoughDiscard_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .build()

        // When
        // Then
        let action = GameAction.draw()
        await #expect(throws: GameError.insufficientDeck) {
            try await dispatch(action, state: state)
        }
    }
}
