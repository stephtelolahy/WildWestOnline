//
//  HandicapTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class HandicapTests: XCTestCase {
    func test_handicap_withCardNotInPlay_shouldPutcardInTargetInPlay() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.handicap("c1", target: "p2", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").hand, ["c2"])
        XCTAssertEqual(result.player("p2").inPlay, ["c1"])
        XCTAssertEqual(result.player("p1").inPlay, [])
        XCTAssertEqual(result.discard.count, 0)
    }

    func test_handicap_withCardAlreadyInPlay_shouldThrowError() {
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
        let action = GameAction.handicap("c-1", target: "p2", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.error, .cardAlreadyInPlay("c"))
    }
}
