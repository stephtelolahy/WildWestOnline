//
//  DamageTest.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

import Testing
import GameFeature

struct DamageTest {
    @Test func damage_with1LifePoint_shouldReduceHealthBy1() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").health == 1)
    }

    @Test func damage_with2LifePoints_shouldReduceHealthBy2() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()

        // When
        let action = GameFeature.Action.damage(2, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").health == 0)
    }
}
