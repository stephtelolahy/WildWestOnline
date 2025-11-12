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

    @Test func startTurn_shouldResetPlayCounters() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayedThisTurn(["c1": 1, "c2": 1])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.playedThisTurn.isEmpty)
    }

    @Test func startTurn_shouldSetCardsToDraw() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withCardsToDrawThisTurn(0)
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.cardsToDrawThisTurn == 2)
    }
}
