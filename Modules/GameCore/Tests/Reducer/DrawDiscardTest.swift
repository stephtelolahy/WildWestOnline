//
//  DrawDiscardTest.swift
//  BangTest
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore

struct DrawDiscardTest {
    @Test func drawDiscard_shouldRemoveTopCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.drawDiscard(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c1"])
        #expect(result.discard == ["c2"])
    }

    @Test func drawDiscard_whitEmptyDiscard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        // Then
        let action = GameFeature.Action.drawDiscard(player: "p1")
        await #expect(throws: GameFeature.Error.insufficientDiscard) {
            try await dispatch(action, state: state)
        }
    }
}
