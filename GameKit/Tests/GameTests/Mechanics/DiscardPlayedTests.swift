//
//  DiscardPlayedTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Game
import XCTest

final class DiscardPlayedTests: XCTestCase {
    func test_discardPlayed_shouldRemoveCardFromHand() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.discardPlayed("c1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").hand, ["c2"])
        XCTAssertEqual(result.discard, ["c1"])
    }
}
