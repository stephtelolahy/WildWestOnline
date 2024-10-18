//
//  DiscardHandTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import GameCore
import Testing

struct DiscardHandTests {
    @Test func discardHand_shouldRemoveCardFromHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.discardHand("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").hand == ["c2"])
        #expect(result.discard == ["c1"])
    }
}
