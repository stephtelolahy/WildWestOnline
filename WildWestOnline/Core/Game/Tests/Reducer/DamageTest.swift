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
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.damage(1, player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").health == 1)
    }

    @Test func damage_with2LifePoints_shouldReduceHealthBy2() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.damage(2, player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").health == 0)
    }
}
