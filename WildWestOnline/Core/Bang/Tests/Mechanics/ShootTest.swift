//
//  ShootTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/11/2024.
//

import Testing
import Bang

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
        #expect(result.queue.first == GameAction.damage(1, player: "p2"))
    }
}
