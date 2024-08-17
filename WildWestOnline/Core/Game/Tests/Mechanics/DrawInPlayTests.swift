//
//  DrawInPlayTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class DrawInPlayTests: XCTestCase {
    func test_drawInPlay_shouldRemoveCardFromTargetInPlay() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.stealInPlay("c21", target: "p2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.hand["p1"], ["c21"])
        XCTAssertEqual(result.field.inPlay["p2"], ["c22"])
    }
}
