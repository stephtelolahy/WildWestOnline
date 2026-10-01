//
//  DrawDeckTest.swift
//  BangTest
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore

struct DrawDeckTest {
    @Test func drawDeck_shouldRemoveTopCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.drawDeck(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c1"])
        #expect(result.deck == ["c2"])
    }

    @Test func drawDeck_shouldResetDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2", "c3", "c4"])
            .build()

        // When
        let action = GameFeature.Action.drawDeck(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.deck == ["c3", "c4"])
        #expect(result.discard == ["c1"])
        #expect(result.players.get("p1").hand == ["c2"])
    }

    @Test func drawDeck_whitEmptyDeckAndNotEnoughDiscardPile_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        // Then
        let action = GameFeature.Action.drawDeck(player: "p1")
        await #expect(throws: GameFeature.Error.insufficientDeck) {
            try await dispatch(action, state: state)
        }
    }
}
