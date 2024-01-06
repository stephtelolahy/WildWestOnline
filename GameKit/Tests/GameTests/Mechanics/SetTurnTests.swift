//
//  SetTurnTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import Game
import XCTest

final class SetTurnTests: XCTestCase {
    func test_setTurn_shouldSetAttributeAndResetCounters() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayedThisTurn(["card1": 1, "card2": 1])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.turn, "p1")
        XCTAssertEqual(result.playedThisTurn, [:])
    }
}
