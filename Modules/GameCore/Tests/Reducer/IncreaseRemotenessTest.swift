//
//  IncreaseRemotenessTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct IncreaseRemotenessTest {
    @Test func increaseRemoteness() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withRemoteness(0)
            }
            .build()

        let result = try await dispatch(.increaseRemoteness(1, player: "p1"), state: state)

        #expect(result.players.get("p1").remoteness == 1)
    }
}
