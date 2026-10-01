//
//  EliminateOnDamageLethalTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct EliminateOnDamageLethalTest {
    @Test func beingDamaged_lethal_shouldBeEliminated() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 1)
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .damage(1, player: "p1"),
            .eliminate(player: "p1")
        ])
    }

    @Test func beingDamaged_nonLethal_shouldRemainActive() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 2)
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1"), state: state)

        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
