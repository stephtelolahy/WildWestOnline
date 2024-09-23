//
//  DrawDiscoveredTests.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

import GameCore
import Testing

struct DrawDiscoveredTests {
    @Test func drawingDiscovered_shouldDrawCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscovered(["c1", "c2"])
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDiscovered("c2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.hand["p1"] == ["c2"])
        #expect(result.field.discovered == ["c1"])
        #expect(result.field.deck == ["c1"])
    }
}
