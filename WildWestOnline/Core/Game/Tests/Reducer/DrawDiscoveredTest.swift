//
//  DrawDiscoveredTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore

struct DrawDiscoveredTest {
    @Test func drawDiscovered_shouldDrawDeckCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscovered(["c1", "c2"])
            .withDeck(["c1", "c2"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.drawDiscovered("c2", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c2"])
        await #expect(sut.state.discovered == ["c1"])
        await #expect(sut.state.deck == ["c1"])
    }
}
