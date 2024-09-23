//
//  StartTurnTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct StartTurnTests {
    @Test func startTurn_shouldSetAttribute() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayedThisTurn(["card1": 1, "card2": 1])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.round.turn == "p1")
    }

    @Test func startTurn_shouldResetPlayCounters() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayedThisTurn(["card1": 1, "card2": 1])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.sequence.played.isEmpty)
    }
}
