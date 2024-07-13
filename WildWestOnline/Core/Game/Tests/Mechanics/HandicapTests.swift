//
//  HandicapTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class HandicapTests: XCTestCase {
    func test_handicap_withCardNotInPlay_shouldPutcardInTargetInPlay() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.handicap("c1", target: "p2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.hand["p1"], ["c2"])
        XCTAssertEqual(result.field.inPlay["p2"], ["c1"])
        XCTAssertEqual(result.field.inPlay["p1"], [])
        XCTAssertEqual(result.field.discard.count, 0)
    }

    func test_handicap_withCardAlreadyInPlay_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-1"])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c-2"])
            }
            .build()

        // When
        // Then
        let action = GameAction.handicap("c-1", target: "p2", player: "p1")
        XCTAssertThrowsError(try GameState.reducer(state, action)) { error in
            XCTAssertEqual(error as? FieldState.Error, .cardAlreadyInPlay("c"))
        }
    }
}
