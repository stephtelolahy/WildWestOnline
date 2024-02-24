//
//  DrawTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import GameCore
import XCTest

final class DrawTests: XCTestCase {
    func test_draw_shouldMoveCardFromDeckToDiscard() throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c2", "c3"])
            .withDiscard(["c1"])
            .build()

        // When
        let action = GameAction.draw
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.discard, ["c2", "c1"])
        XCTAssertEqual(result.deck, ["c3"])
    }
}
