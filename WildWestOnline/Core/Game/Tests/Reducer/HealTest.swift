//
//  HealTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore
import Combine

struct HealTest {
    @Test func heal_beingDamaged_amountLessThanDamage_shouldGainLifePoints() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .build()

        // When
        let action = GameFeature.Action.heal(1, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").health == 3)
    }

    @Test func heal_beingDamaged_amountEqualDamage_shouldGainLifePoints() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .build()

        // When
        let action = GameFeature.Action.heal(2, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").health == 4)
    }

    @Test func heal_beingDamaged_amountGreaterThanDamage_shouldGainLifePointsLimitedToMaxHealth() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .build()

        // When
        let action = GameFeature.Action.heal(3, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").health == 4)
    }

    @Test func heal_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(4)
                    .withMaxHealth(4)
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.heal(1, player: "p1")
        await #expect(throws: Card.Failure.playerAlreadyMaxHealth("p1")) {
            try await dispatch(action, state: state)
        }
    }
}
