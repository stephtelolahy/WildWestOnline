//
//  IncreaseRemotenessTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct IncreaseRemotenessTest {
    @Test func increseRemoteness_shouldUpdatePlayerAttribute() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withRemoteness(0)
            }
            .build()

        // When
        let action = GameFeature.Action.increaseRemoteness(1, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").remoteness == 1)
    }
}
