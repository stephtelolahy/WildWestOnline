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
        let state = GameFeature.State.makeBuilder()
            .build()

        let result = try await dispatch(.activate(["c1", "c2"], player: "p1"), state: state)

        let playable = try #require(result.playable)
        #expect(playable.player == "p1")
        #expect(playable.cards == ["c1", "c2"])
    }
}
