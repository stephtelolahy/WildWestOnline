//
//  WinchesterTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class WinchesterTests: XCTestCase {
    func test_playWinchester_shouldEquipAndSetAttribute() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.winchester])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.weapon: 1])
            }
            .build()

        // When
        let action = GameAction.play(.winchester, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.winchester, player: "p1"),
            .equip(.winchester, player: "p1"),
            .setAttribute(.weapon, value: 5, player: "p1")
        ])
    }
}
