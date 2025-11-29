//
//  DrawDiscoveredTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameFeature

struct DrawDiscoveredTest {
    @Test func drawDiscovered_shouldDrawDeckCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withDiscovered(["c1", "c2"])
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.drawDiscovered("c2", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discovered == ["c1"])
        #expect(result.deck == ["c1"])
    }
}
