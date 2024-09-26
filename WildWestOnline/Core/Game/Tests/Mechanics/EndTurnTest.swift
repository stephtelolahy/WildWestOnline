//
//  EndTurnTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
import GameCore

struct EndTurnTest {
    @Test func endTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.endTurn(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.turn == nil)
    }
}
