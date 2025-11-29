//
//  DrawTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameFeature

struct DrawTest {
    @Test func draw_shouldMoveCardFromDeckToDiscard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withDeck(["c2", "c3"])
            .withDiscard(["c1"])
            .build()

        // When
        let action = GameFeature.Action.draw(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.discard == ["c2", "c1"])
        #expect(result.deck == ["c3"])
    }

    @Test func draw_withEmptyDeck_shouldResetDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withDiscard(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.draw(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.discard == ["c2", "c1"])
        #expect(result.deck == ["c3"])
    }

    @Test func draw_withEmptyDeck_withoutEnoughDiscard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .build()

        // When
        // Then
        let action = GameFeature.Action.draw(player: "p1")
        await #expect(throws: GameFeature.Error.insufficientDeck) {
            try await dispatch(action, state: state)
        }
    }
}
