//
//  DiscardPlayedTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 15/12/2024.
//

import Testing
import GameCore

struct DiscardPlayedTest {
    @Test func discardPlayed_shouldRemoveCardFromHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.discardPlayed("c1", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c2"])
        await #expect(sut.state.discard == ["c1"])
    }
}
