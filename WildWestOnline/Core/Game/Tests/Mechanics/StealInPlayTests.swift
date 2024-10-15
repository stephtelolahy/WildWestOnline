//
//  StealInPlayTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct StealInPlayTests {
    @Test func stealInPlay_shouldRemoveCardFromTargetInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.stealInPlay("c21", target: "p2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").hand == ["c21"])
        #expect(result.player("p2").inPlay == ["c22"])
    }
}
