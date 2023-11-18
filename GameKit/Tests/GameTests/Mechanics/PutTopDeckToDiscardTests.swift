//
//  PutTopDeckToDiscardTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import Game
import XCTest

final class PutTopDeckToDiscardTests: XCTestCase {
    func test_putTopDeckToDiscard_shouldMoveCardFromDeckToDiscard() throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c2", "c3"])
            .withDiscard(["c1"])
            .build()

        // When
        let action = GameAction.luck
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.discard.top, "c2")
        XCTAssertEqual(result.deck.top, "c3")
    }
}
