//
//  IncreaseMagnifyingTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct IncreaseMagnifyingTest {
    @Test func increseMagnifying_shouldUpdatePlayerAttribute() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withMagnifying(0)
            }
            .build()

        // When
        let action = GameFeature.Action.increaseMagnifying(1, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").magnifying == 1)
    }
}
