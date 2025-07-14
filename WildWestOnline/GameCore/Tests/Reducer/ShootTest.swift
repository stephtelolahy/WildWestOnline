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
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.shoot("p2")
        let result = try await dispatch(action, state: state)

        // Then
        let pending = try #require(result.queue.first)
        #expect(pending.name == .damage)
        #expect(pending.payload.target == "p2")
        #expect(pending.payload.amount == 1)
    }
}
