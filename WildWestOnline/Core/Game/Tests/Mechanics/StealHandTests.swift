//
//  StealHandTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct StealHandTests {
    @Test func stealHand_shouldRemoveCardFromTargetHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.stealHand("c21", target: "p2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.hand["p1"] == ["c21"])
        #expect(result.field.hand["p2"] == ["c22"])
    }
}
