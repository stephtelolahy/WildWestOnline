//
//  RevCarabineTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class RevCarabineTests: XCTestCase {
    func test_playRevCarabine_shouldEquipAndSetWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.revCarabine])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.weapon: 1])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.revCarabine, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.revCarabine, player: "p1"),
            .equip(.revCarabine, player: "p1"),
            .setAttribute(.weapon, value: 4, player: "p1")
        ])
    }
}
