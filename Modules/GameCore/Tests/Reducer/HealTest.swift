//
//  HealTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct HealTest {
    /// Healing a damaged player gains life points, limited to max health
    @Test(arguments: [(1, 3), (2, 4), (3, 4)])
    func heal_beingDamaged_shouldGainLifePoints(amount: Int, expectedHealth: Int) async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", health: 2) { $0.withMaxHealth(4) }
            .build()

        let result = try await dispatch(.heal(amount, player: "p1"), state: state)

        #expect(result.players.get("p1").health == expectedHealth)
    }

    @Test func heal_alreadyMaxHealth_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", health: 4) { $0.withMaxHealth(4) }
            .build()

        await #expect(throws: GameFeature.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatch(.heal(1, player: "p1"), state: state)
        }
    }
}
