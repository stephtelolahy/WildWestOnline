//
//  UndiscoverTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 12/11/2025.
//
import Testing
import GameFeature

struct UndiscoverTest {
    @Test func undiscover_shouldResetDiscoveredCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withDiscovered(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.undiscover()
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.discovered.isEmpty)
    }
}
