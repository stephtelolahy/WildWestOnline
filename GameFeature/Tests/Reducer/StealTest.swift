//
//  StealTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 04/11/2024.
//

import Testing
import GameFeature

struct StealTest {
    @Test func steal_shouldRemoveCardFromTargetHand() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
            }
            .build()

        // When
        let action = GameFeature.Action.stealHand("c21", target: "p2", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c21"])
        #expect(result.players.get("p2").hand == ["c22"])
    }

    @Test func steal_shouldRemoveCardFromTargetInPlay() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameFeature.Action.stealInPlay("c21", target: "p2", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c21"])
        #expect(result.players.get("p2").inPlay == ["c22"])
    }
}
