//
//  StartTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//

import Testing
import GameFeature

struct StartTurnTest {
    @Test func startTurn_shouldSetTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.turn == "p1")
    }
}
