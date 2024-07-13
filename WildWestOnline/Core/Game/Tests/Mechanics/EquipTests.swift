//
//  EquipTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class EquipTests: XCTestCase {
    func test_equip_withCardNotInPlay_shouldPutCardInPlay() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.equip("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.hand["p1"], ["c2"])
        XCTAssertEqual(result.field.inPlay["p1"], ["c1"])
        XCTAssertEqual(result.field.discard.count, 0)
    }

    func test_equip_withCardAlreadyInPlay_shouldThrowError() throws {
        // Given
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-1"])
                    .withInPlay(["c-2"])
            }
            .build()

        // When
        // Then
        let action = GameAction.equip("c-1", player: "p1")
        XCTAssertThrowsError(try GameState.reducer(state, action)) { error in
            XCTAssertEqual(error as? FieldState.Error, .cardAlreadyInPlay("c"))
        }
    }
}
