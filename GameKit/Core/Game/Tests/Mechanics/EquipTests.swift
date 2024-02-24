//
//  EquipTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class EquipTests: XCTestCase {
    func test_equip_withCardNotInPlay_shouldPutCardInPlay() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.equip("c1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").hand, ["c2"])
        XCTAssertEqual(result.player("p1").inPlay, ["c1"])
        XCTAssertEqual(result.discard.count, 0)
    }

    func test_equip_withCardAlreadyInPlay_shouldThrowError() {
        // Given
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-1"])
                    .withInPlay(["c-2"])
            }
            .build()

        // When
        let action = GameAction.equip("c-1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.error, .cardAlreadyInPlay("c"))
    }
}
