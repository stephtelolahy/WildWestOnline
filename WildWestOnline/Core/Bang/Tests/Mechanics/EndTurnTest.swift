//
//  EndTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//

import Testing
import Bang

struct EndTurnTest {
    @Test func endTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.endTurn(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.turn == nil)
    }
}
