//
//  PassInPlayTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import GameCore
import Testing

struct PassInPlayTests {
    @Test func passInPlay_shouldRemoveCardFromInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.passInPlay("c1", target: "p2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.inPlay["p1"] == ["c2"])
        #expect(result.field.inPlay["p2"] == ["c1"])
    }
}
