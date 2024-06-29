//
//  HealTests.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import GameCore
import XCTest

final class HealTests: XCTestCase {
    private var state: GameState {
        GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .build()
    }

    func test_heal_beingDamaged_amountLessThanDamage_shouldGainLifePoints() {
        // When
        let action = GameAction.heal(1, player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.playerState("p1").health, 3)
    }

    func test_heal_beingDamaged_amountEqualDamage_shouldGainLifePoints() {
        // When
        let action = GameAction.heal(2, player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.playerState("p1").health, 4)
    }

    func test_heal_beingDamaged_amountGreaterThanDamage_shouldGainLifePointsLimitedToMaxHealth() {
        // When
        let action = GameAction.heal(3, player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.playerState("p1").health, 4)
    }

    func test_heal_alreadyMaxHealth_shouldThrowError() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHealth(4)
                    .withAttributes([.maxHealth: 4])
            }
            .build()

        // When
        let action = GameAction.heal(1, player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.error, .playerAlreadyMaxHealth("p1"))
    }
}
