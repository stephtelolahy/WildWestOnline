//
//  ActivateTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
import GameCore

struct ActivateTest {
    @Test func activate() async throws {
        // Given
        let state = GameState.makeBuilder().build()

        // When
        let action = GameAction.activate(["c1", "c2"], player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.active == ["p1": ["c1", "c2"]])
    }
}
