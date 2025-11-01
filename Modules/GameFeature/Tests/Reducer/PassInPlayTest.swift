//
//  PassInPlayTest.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameFeature

struct PassInPlayTest {
    @Test func passInPlay_shouldRemoveCardFromInPlay() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.passInPlay("c1", target: "p2", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").inPlay == ["c2"])
        #expect(result.players.get("p2").inPlay == ["c1"])
    }
}
