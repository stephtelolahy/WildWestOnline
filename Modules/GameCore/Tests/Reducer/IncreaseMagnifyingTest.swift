//
//  IncreaseMagnifyingTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct IncreaseMagnifyingTest {
    @Test func increaseMagnifying() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withMagnifying(0)
            }
            .build()

        let result = try await dispatch(.increaseMagnifying(1, player: "p1"), state: state)

        #expect(result.players.get("p1").magnifying == 1)
    }
}
