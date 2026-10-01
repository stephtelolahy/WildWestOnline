//
//  HealTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct HealTest {
    @Test func heal_beingDamaged_amountLessThanDamage_shouldGainLifePoints() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .build()

        let result = try await dispatch(.heal(1, player: "p1"), state: state)

        #expect(result.players.get("p1").health == 3)
    }

    @Test func heal_beingDamaged_amountEqualDamage_shouldGainLifePoints() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .build()

        let result = try await dispatch(.heal(2, player: "p1"), state: state)

        #expect(result.players.get("p1").health == 4)
    }

    @Test func heal_beingDamaged_amountGreaterThanDamage_shouldGainLifePointsLimitedToMaxHealth() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .build()

        let result = try await dispatch(.heal(3, player: "p1"), state: state)

        #expect(result.players.get("p1").health == 4)
    }

    @Test func heal_alreadyMaxHealth_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(4)
                    .withMaxHealth(4)
            }
            .build()

        await #expect(throws: GameFeature.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatch(.heal(1, player: "p1"), state: state)
        }
    }
}
