//
//  DiscardTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

import Testing
import GameFeature

struct DiscardTest {
    @Test func discard_shouldRemoveCardFromHand() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.discardHand("c1", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discard == ["c1"])
    }

    @Test func discard_shouldRemoveCardFromInPlay() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.discardInPlay("c1", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").inPlay == ["c2"])
        #expect(result.discard == ["c1"])
    }
}
