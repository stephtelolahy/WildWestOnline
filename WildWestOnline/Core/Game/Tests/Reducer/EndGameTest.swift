//
//  EndGameTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 14/11/2024.
//

import Testing
import GameCore

struct EndGameTest {
    @Test func endGame() async throws {
        // Given
        let state = GameState.makeBuilder()
            .build()

        // When
        let action = GameAction.endGame(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.isOver == true)
    }
}
