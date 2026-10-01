//
//  DamageTest.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

import Testing
import GameCore

struct DamageTest {
    @Test func damage_with1LifePoint_shouldReduceHealthBy1() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", health: 2)
            .build()

        let result = try await dispatch(.damage(1, player: "p1"), state: state)

        #expect(result.players.get("p1").health == 1)
    }

    @Test func damage_with2LifePoints_shouldReduceHealthBy2() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", health: 2)
            .build()

        let result = try await dispatch(.damage(2, player: "p1"), state: state)

        #expect(result.players.get("p1").health == 0)
    }
}
