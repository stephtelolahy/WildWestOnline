//
//  DiscoverTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import GameCore
import Testing

struct DiscoverTests {
    @Test func discover_shouldAddCardToDiscovered() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.discover(2)
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.discovered == ["c1", "c2"])
        #expect(result.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_emptyDeck_shouldResetDeck() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck([])
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameAction.discover(1)
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.discovered == ["c2"])
        #expect(result.deck == ["c2"])
        #expect(result.discard == ["c1"])
    }
}
