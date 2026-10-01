//
//  DrawDiscoveredTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore

struct DrawDiscoveredTest {
    @Test func drawDiscovered_shouldDrawDeckCard() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withDiscovered(["c1", "c2"])
            .withDeck(["c1", "c2"])
            .build()

        let result = try await dispatch(.drawDiscovered("c2", player: "p1"), state: state)

        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discovered == ["c1"])
        #expect(result.deck == ["c1"])
    }
}
