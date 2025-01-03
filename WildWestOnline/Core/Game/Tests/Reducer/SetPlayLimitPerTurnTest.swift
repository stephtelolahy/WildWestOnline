//
//  SetPlayLimitPerTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 20/12/2024.
//

import Testing
import GameCore

struct SetPlayLimitPerTurnTest {
    @Test func setPlayLimitPerTurn_shouldSetValue() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.setPlayLimitPerTurn(["c1": 2], player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").playLimitPerTurn["c1"] == 2)
    }
}
