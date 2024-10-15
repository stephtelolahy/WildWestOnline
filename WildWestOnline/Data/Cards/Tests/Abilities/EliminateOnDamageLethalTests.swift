//
//  EliminateOnDamageLethalTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct EliminateOnDamageLethalTests {
    @Test func beingDamaged_lethal_shouldBeEliminated() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHealth(1)
                    .withAbilities([.eliminateOnDamageLethal])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .eliminate(player: "p1")
        ])
    }

    @Test func beingDamaged_nonLethal_shouldRemainActive() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withAbilities([.eliminateOnDamageLethal])
            }
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
