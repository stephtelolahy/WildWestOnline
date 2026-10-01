//
//  PlayTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 15/12/2024.
//

import Testing
import GameCore

struct PlayTest {
    @Test func play_shouldRemoveCardFromHand() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c1", "c2"])
            .withCards(["c1": Card(name: "c1", type: .collectible)])
            .build()

        let result = try await dispatch(.play("c1", player: "p1"), state: state)

        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discard == ["c1"])
    }
}
