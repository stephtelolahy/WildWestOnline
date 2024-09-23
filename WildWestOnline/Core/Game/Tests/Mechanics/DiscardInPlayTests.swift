//
//  DiscardInPlayTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import GameCore
import Testing

struct DiscardInPlayTests {
    @Test func discardInPlay_shouldRemoveCardFromInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.discardInPlay("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.inPlay["p1"] == ["c2"])
        #expect(result.field.discard == ["c1"])
    }
}
