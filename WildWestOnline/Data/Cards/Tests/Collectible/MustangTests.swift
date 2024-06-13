//
//  MustangTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class MustangTests: XCTestCase {
    func test_playMustang_shouldEquipAndSetAttribute() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.mustang])
                    .withAbilities([.updateAttributesOnChangeInPlay])
            }
            .build()

        // When
        let action = GameAction.play(.mustang, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.mustang, player: "p1"),
            .equip(.mustang, player: "p1"),
            .setAttribute(.remoteness, value: 1, player: "p1")
        ])
    }
}
