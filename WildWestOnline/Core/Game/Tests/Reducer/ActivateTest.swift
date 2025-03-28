//
//  ActivateTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 24/11/2024.
//

import Testing
import GameCore

struct ActivateTest {
    @Test func activate() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .build()

        // When
        let action = GameFeature.Action.activate(["c1", "c2"], player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.active == ["p1": ["c1", "c2"]])
    }
}
