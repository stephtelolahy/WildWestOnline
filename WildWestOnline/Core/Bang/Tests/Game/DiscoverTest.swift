//
//  DiscoverTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import Bang

struct DiscoverTest {
    @Test func discover_shouldAddCardToDiscovered() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.discover
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.discovered == ["c1"])
        #expect(result.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_withAlreadyDiscoveredCard_shouldAddCardNextToDiscovered() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .withDiscovered(["c1"])
            .build()

        // When
        let action = GameAction.discover
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.discovered == ["c1", "c2"])
        #expect(result.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_emptyDeck_withEnoughCards_shouldResetDeck() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck([])
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameAction.discover
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.discovered == ["c2"])
        #expect(result.deck == ["c2"])
        #expect(result.discard == ["c1"])
    }

    @Test func discover_emptyDeck_withoutEnoughCards_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .build()

        // When
        // Then
        let action = GameAction.discover
        #expect(throws: GameError.deckIsEmpty) {
            try GameReducer().reduce(state, action)
        }
    }
}