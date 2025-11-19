//
//  ShootTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/11/2024.
//

import Testing
@testable import GameFeature

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
        #expect(pending.targetedPlayer == "p2")
        #expect(pending.amount == 1)
    }
}
