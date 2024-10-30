//
//  DrawDiscoveredTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import Bang

struct DrawDiscoveredTest {
    @Test func drawingDiscovered_shouldDrawCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscovered(["c1", "c2"])
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDiscovered("c2", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discovered == ["c1"])
        #expect(result.deck == ["c1"])
    }
}
