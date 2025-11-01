//
//  EndGameTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 14/11/2024.
//

import Testing
import GameFeature

struct EndGameTest {
    @Test func endGame() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .build()

        // When
        let action = GameFeature.Action.endGame(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.isOver == true)
    }
}
