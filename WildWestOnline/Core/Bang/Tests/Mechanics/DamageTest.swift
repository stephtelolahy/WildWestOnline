//
//  DamageTests.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

import Bang
import Testing

struct DamageTest {
    func damage_with1LifePoint_shouldReduceHealthBy1() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").health == 1)
    }

    func damage_with2LifePoints_shouldReduceHealthBy2() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()

        // When
        let action = GameAction.damage(2, player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").health == 0)
    }
}
