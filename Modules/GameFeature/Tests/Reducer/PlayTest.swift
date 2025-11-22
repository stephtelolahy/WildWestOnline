//
//  PlayTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 15/12/2024.
//

import Testing
@testable import GameFeature

struct PlayTest {
    @Test func play_shouldRemoveCardFromHand() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withCards(["c1": Card(name: "c1", type: .collectible)])
            .build()

        // When
        let action = GameFeature.Action.play("c1", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discard == ["c1"])
    }

    @Test func play_shouldSaveEvent() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", type: .collectible)])
            .build()

        // When
        let action = GameFeature.Action.play("c1", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.events == [action])
    }
}
