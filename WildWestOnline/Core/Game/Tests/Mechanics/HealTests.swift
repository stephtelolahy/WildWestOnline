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
                    .withAttributes([.maxHealth: 4])
            }
            .build()
    }

    func test_heal_beingDamaged_amountLessThanDamage_shouldGainLifePoints() throws {
        // When
        let action = GameAction.heal(1, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").health, 3)
    }

    func test_heal_beingDamaged_amountEqualDamage_shouldGainLifePoints() throws {
        // When
        let action = GameAction.heal(2, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").health, 4)
    }

    func test_heal_beingDamaged_amountGreaterThanDamage_shouldGainLifePointsLimitedToMaxHealth() throws {
        // When
        let action = GameAction.heal(3, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").health, 4)
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
        // Then
        let action = GameAction.heal(1, player: "p1")
        XCTAssertThrowsError(try GameState.reducer(state, action)) { error in
            XCTAssertEqual(error as? PlayersState.Error, .playerAlreadyMaxHealth("p1"))
        }
    }
}
