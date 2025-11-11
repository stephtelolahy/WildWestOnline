//
//  SetPlayLimitsPerTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 20/12/2024.
//

import Testing
import GameFeature

struct SetPlayLimitsPerTurnTest {
    @Test func setPlayLimitsPerTurn_shouldSetValue() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        let action = GameFeature.Action.setPlayLimitsPerTurn(["c1": 2], player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").playLimitsPerTurn["c1"] == 2)
    }
}
