//
//  UndiscoverTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 12/11/2025.
//
import Testing
import GameCore

struct UndiscoverTest {
    @Test func undiscover_shouldResetDiscoveredCards() async throws {
        let state = GameFeature.State.makeBuilder()
            .withDiscovered(["c1", "c2"])
            .build()

        let result = try await dispatch(.undiscover(), state: state)

        #expect(result.discovered.isEmpty)
    }
}
