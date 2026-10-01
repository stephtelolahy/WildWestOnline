//
//  StartTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//

import Testing
import GameCore

struct StartTurnTest {
    @Test func startTurn_shouldSetTurn() async throws {
        let state = GameFeature.State.makeBuilder()
            .build()

        let result = try await dispatch(.startTurn(player: "p1"), state: state)

        #expect(result.turn == "p1")
    }
}
