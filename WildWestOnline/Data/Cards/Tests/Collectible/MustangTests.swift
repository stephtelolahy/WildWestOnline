//
//  MustangTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class MustangTests: XCTestCase {
    func test_playMustang_shouldEquipAndSetAttribute() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.mustang])
                    .withAbilities([.updateAttributesOnChangeInPlay])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.mustang, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playEquipment(.mustang, player: "p1"),
            .setAttribute(.remoteness, value: 1, player: "p1")
        ])
    }
}
