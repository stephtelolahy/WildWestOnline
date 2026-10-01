//
//  GatlingTest.swift
//
//
//  Created by Hugues Telolahy on 22/04/2023.
//

import Testing
import GameCore

struct GatlingTest {
    @Test func play_shouldDamageOtherPlayers() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.gatling])
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.gatling, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.gatling, player: "p1"),
            .play(.gatling, player: "p1"),
            .shoot("p2"),
            .damage(1, player: "p2"),
            .shoot("p3"),
            .damage(1, player: "p3")
        ])
    }
}
