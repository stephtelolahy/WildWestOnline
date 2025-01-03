//
//  ShootTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/11/2024.
//

import Testing
import GameCore

struct ShootTest {
    @Test func shoot() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.shoot("p2", player: "p1")
        await sut.dispatch(action)

        // Then
        let pending = try await #require(sut.state.queue.first)
        #expect(pending.kind == .damage)
        #expect(pending.payload.target == "p2")
        #expect(pending.payload.amount == 1)
    }
}
