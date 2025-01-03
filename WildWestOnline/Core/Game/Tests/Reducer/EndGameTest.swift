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
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.endGame(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.isOver == true)
    }
}
