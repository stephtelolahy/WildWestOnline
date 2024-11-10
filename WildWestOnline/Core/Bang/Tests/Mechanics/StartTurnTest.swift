//
//  StartTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//

import Testing
import Bang

struct StartTurnTest {
    @Test func startTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.turn == "p1")
    }
}
