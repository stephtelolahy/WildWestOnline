//
//  PutBackHandTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import GameCore
import XCTest

final class PutBackHandTests: XCTestCase {
    func test_putBack_shouldMoveCardFromHandToTopDeck() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.putBack("c1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.deck, ["c1", "c2"])
        XCTAssertEqual(result.player("p1").hand, [])
    }
}
