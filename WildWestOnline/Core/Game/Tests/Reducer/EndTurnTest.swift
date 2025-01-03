//
//  EndTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//

import Testing
import GameCore

struct EndTurnTest {
    @Test func endTurn_shouldUnsetTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withTurn("p1")
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.endTurn(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.turn == nil)
    }
}
