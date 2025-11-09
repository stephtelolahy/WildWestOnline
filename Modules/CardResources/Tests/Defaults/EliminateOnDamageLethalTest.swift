//
//  EliminateOnDamageLethalTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct EliminateOnDamageLethalTest {
    @Test func beingDamaged_lethal_shouldBeEliminated() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHealth(1)
                    .withAbilities([.eliminateOnDamagedLethal])
            }
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .eliminate(player: "p1")
        ])
    }

    @Test func beingDamaged_nonLethal_shouldRemainActive() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withAbilities([.eliminateOnDamagedLethal])
            }
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
