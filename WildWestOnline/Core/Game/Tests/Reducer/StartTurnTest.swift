//
//  StartTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//

import Testing
import GameCore

struct StartTurnTest {
    @Test func startTurn_shouldSetTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.startTurn(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.turn == "p1")
    }

    @Test func startTurn_shouldResetPlayCounters() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayedThisTurn(["c1": 1, "c2": 1])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.startTurn(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playedThisTurn.isEmpty)
    }
}
