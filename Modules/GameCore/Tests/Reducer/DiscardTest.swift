//
//  DiscardTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

import Testing
import GameCore

struct DiscardTest {
    @Test func discard_shouldRemoveCardFromHand() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c1", "c2"])
            .build()

        let result = try await dispatch(.discardHand("c1", player: "p1"), state: state)

        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discard == ["c1"])
    }

    @Test func discard_shouldRemoveCardFromInPlay() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", inPlay: ["c1", "c2"])
            .build()

        let result = try await dispatch(.discardInPlay("c1", player: "p1"), state: state)

        #expect(result.players.get("p1").inPlay == ["c2"])
        #expect(result.discard == ["c1"])
    }
}
