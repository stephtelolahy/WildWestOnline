//
//  DrawHandTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class DrawHandTests: XCTestCase {
    func test_drawHand_shouldRemoveCardFromTargetHand() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.drawHand("c21", target: "p2", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").hand, ["c21"])
        XCTAssertEqual(result.player("p2").hand, ["c22"])
    }
}
