//
//  StartTurnTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class StartTurnTests: XCTestCase {
    func test_startTurn_shouldSetAttribute() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayedThisTurn(["card1": 1, "card2": 1])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.round.turn, "p1")
    }

    func test_startTurn_shouldResetPlayCounters() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayedThisTurn(["card1": 1, "card2": 1])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.sequence.played, [:])
    }
}
