//
//  PassInPlayTest.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct PassInPlayTest {
    @Test func passInPlay_shouldRemoveCardFromInPlay() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", inPlay: ["c1", "c2"])
            .withPlayer("p2")
            .build()

        let result = try await dispatch(.passInPlay("c1", target: "p2", player: "p1"), state: state)

        #expect(result.players.get("p1").inPlay == ["c2"])
        #expect(result.players.get("p2").inPlay == ["c1"])
    }
}
