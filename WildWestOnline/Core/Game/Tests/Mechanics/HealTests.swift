//
//  HealTests.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import GameCore
import Testing

struct HealTests {
    private var state: GameState {
        GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .build()
    }

    @Test func heal_beingDamaged_amountLessThanDamage_shouldGainLifePoints() async throws {
        // When
        let action = GameAction.heal(1, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").health == 3)
    }

    @Test func heal_beingDamaged_amountEqualDamage_shouldGainLifePoints() async throws {
        // When
        let action = GameAction.heal(2, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").health == 4)
    }

    @Test func heal_beingDamaged_amountGreaterThanDamage_shouldGainLifePointsLimitedToMaxHealth() async throws {
        // When
        let action = GameAction.heal(3, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").health == 4)
    }

    @Test func heal_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(4)
                    .withMaxHealth(4)
            }
            .build()

        // When
        // Then
        let action = GameAction.heal(1, player: "p1")
        #expect(throws: GameState.Error.playerAlreadyMaxHealth("p1")) {
            try GameState.reducer(state, action)
        }
    }
}
