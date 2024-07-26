//
//  EliminateOnDamageLethalTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class EliminateOnDamageLethalTests: XCTestCase {
    func test_beingDamaged_lethal_shouldBeEliminated() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHealth(1)
                    .withAbilities([.eliminateOnDamageLethal])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .damage(1, player: "p1"),
            .eliminate(player: "p1")
        ])
    }

    func test_beingDamaged_nonLethal_shouldRemainActive() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withAbilities([.eliminateOnDamageLethal])
            }
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .damage(1, player: "p1")
        ])
    }
}
