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

        // When
        let action = GameAction.shoot("p2", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        let pending = try #require(result.queue.first)
        #expect(pending.kind == .damage)
        #expect(pending.payload.target == "p2")
        #expect(pending.payload.amount == 1)
    }
}
