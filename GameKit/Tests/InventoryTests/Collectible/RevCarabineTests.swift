//
//  RevCarabineTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
// swiftlint:disable no_magic_numbers

import GameCore
import XCTest

final class RevCarabineTests: XCTestCase {
    func test_playRevCarabine_shouldEquipAndSetWeapon() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.revCarabine])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.weapon: 1])
            }
            .build()

        // When
        let action = GameAction.play(.revCarabine, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.revCarabine, player: "p1"),
            .equip(.revCarabine, player: "p1"),
            .setAttribute(.weapon, value: 4, player: "p1")
        ])
    }
}
