//
//  StealHandTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class StealHandTests: XCTestCase {
    func test_stealHand_shouldRemoveCardFromTargetHand() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.stealHand("c21", target: "p2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.hand["p1"], ["c21"])
        XCTAssertEqual(result.field.hand["p2"], ["c22"])
    }
}
