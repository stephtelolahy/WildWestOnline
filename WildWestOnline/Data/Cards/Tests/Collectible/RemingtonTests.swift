//
//  RemingtonTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class RemingtonTests: XCTestCase {
    func test_playRemington_shouldEquipAndSetWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.remington])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.weapon: 1])
            }
            .build()

        // When
        let action = GameAction.play(.remington, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.remington, player: "p1"),
            .equip(.remington, player: "p1"),
            .setAttribute(.weapon, value: 3, player: "p1")
        ])
    }
}
