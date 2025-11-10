//
//  SetCardPlayLimitsPerTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 20/12/2024.
//

import Testing
import GameFeature

struct SetCardPlayLimitsPerTurnTest {
    @Test func setCardPlayLimitsPerTurn_shouldSetValue() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        let action = GameFeature.Action.setCardPlayLimitsPerTurn(["c1": 2], player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").cardPlayLimitsPerTurn["c1"] == 2)
    }
}
