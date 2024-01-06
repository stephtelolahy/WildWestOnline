//
//  PassInPlayTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Game
import XCTest

final class PassInPlayTests: XCTestCase {
    func test_passInPlay_shouldRemoveCardFromInPlay() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.passInPlay("c1", target: "p2", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").inPlay, ["c2"])
        XCTAssertEqual(result.player("p2").inPlay, ["c1"])
    }
}
