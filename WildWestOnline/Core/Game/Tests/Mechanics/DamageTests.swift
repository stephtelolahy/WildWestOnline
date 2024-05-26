//
//  DamageTests.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

import GameCore
import XCTest

final class DamageTests: XCTestCase {
    func test_damage_with1LifePoint_shouldReduceHealthBy1() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").health, 1)
    }

    func test_damage_with2LifePoints_shouldReduceHealthBy2() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()

        // When
        let action = GameAction.damage(2, player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").health, 0)
    }
}
