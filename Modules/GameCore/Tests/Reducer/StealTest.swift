//
//  StealTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 04/11/2024.
//

import Testing
import GameCore

struct StealTest {
    @Test func steal_shouldRemoveCardFromTargetHand() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2", hand: ["c21", "c22"])
            .build()

        let result = try await dispatch(.stealHand("c21", target: "p2", player: "p1"), state: state)

        #expect(result.players.get("p1").hand == ["c21"])
        #expect(result.players.get("p2").hand == ["c22"])
    }

    @Test func steal_shouldRemoveCardFromTargetInPlay() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2", inPlay: ["c21", "c22"])
            .build()

        let result = try await dispatch(.stealInPlay("c21", target: "p2", player: "p1"), state: state)

        #expect(result.players.get("p1").hand == ["c21"])
        #expect(result.players.get("p2").inPlay == ["c22"])
    }
}
