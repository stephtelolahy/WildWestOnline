//
//  EndGameTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
import GameCore

struct EndGameTest {
    @Test func endGame() async throws {
        // Given
        let state = GameState.makeBuilder().build()

        // When
        let action = GameAction.endGame(winner: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.winner == "p1")
    }
}
