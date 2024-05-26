//
//  DrawInPlayTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class DrawInPlayTests: XCTestCase {
    func test_drawInPlay_shouldRemoveCardFromTargetInPlay() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.drawInPlay("c21", target: "p2", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").hand, ["c21"])
        XCTAssertEqual(result.player("p2").inPlay, ["c22"])
    }
}
