//
//  ShootTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/11/2024.
//

import Testing
@testable import GameCore

struct ShootTest {
    @Test func shoot() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        let result = try await dispatch(.shoot("p2"), state: state)

        let pending = try #require(result.queue.first)
        #expect(pending.name == .damage)
        #expect(pending.targetedPlayer == "p2")
        #expect(pending.amount == 1)
        #expect(pending.requiredMisses == 1)
    }
}
