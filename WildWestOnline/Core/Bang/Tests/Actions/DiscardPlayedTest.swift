//
//  DiscardPlayedTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 15/12/2024.
//

import Testing
import Bang

struct DiscardPlayedTest {
    @Test func discardPlayed_shouldRemoveCardFromHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.discardPlayed("c1", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discard == ["c1"])
    }
}
