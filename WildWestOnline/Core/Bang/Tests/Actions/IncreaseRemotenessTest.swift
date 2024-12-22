//
//  IncreaseRemotenessTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import Bang

struct IncreaseRemotenessTest {
    @Test func increseRemoteness_shouldUpdatePlayerAttribute() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withRemoteness(0)
            }
            .build()

        // When
        let action = GameAction.increaseRemoteness(1, player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").remoteness == 1)
    }
}
