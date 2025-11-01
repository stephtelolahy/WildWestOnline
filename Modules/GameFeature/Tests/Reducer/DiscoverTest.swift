//
//  DiscoverTest.swift
//  BangTest
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameFeature
import Combine

struct DiscoverTest {
    @Test func discover_shouldAddCardToDiscovered() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.discover()
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.discovered == ["c1"])
        #expect(result.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_withAlreadyDiscoveredCard_shouldAddCardNextToDiscovered() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .withDiscovered(["c1"])
            .build()

        // When
        let action = GameFeature.Action.discover()
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.discovered == ["c1", "c2"])
        #expect(result.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_emptyDeck_withEnoughCards_shouldResetDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withDeck([])
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.discover()
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.discovered == ["c2"])
        #expect(result.deck == ["c2"])
        #expect(result.discard == ["c1"])
    }

    @Test func discover_emptyDeck_withoutEnoughCards_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .build()

        // When
        // Then
        let action = GameFeature.Action.discover()
        await #expect(throws: GameFeature.Error.insufficientDeck) {
            try await dispatch(action, state: state)
        }
    }

    @Test func discover_nonEmptyDeck_withoutEnoughCards_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withDiscovered(["c1"])
            .withDeck(["c1"])
            .build()

        // When
        // Then
        let action = GameFeature.Action.discover()
        await #expect(throws: GameFeature.Error.insufficientDeck) {
            try await dispatch(action, state: state)
        }
    }
}
