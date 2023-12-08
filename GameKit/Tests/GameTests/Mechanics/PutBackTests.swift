//
//  PutBackTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import Game
import XCTest

final class PutBackTests: XCTestCase {
    func test_putBack_withArenaSingleCard_shouldMoveCardFromArenaToTopDeck() throws {
        // Given
        let state = GameState.makeBuilder()
            .withArena(["c1"])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.putBack
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.deck, ["c1", "c2"])
        XCTAssertEqual(result.arena, [])
    }

    func test_putBack_withArenaMultipleCards_shouldMoveCardsFromArenaToTopDeck() throws {
        // Given
        let state = GameState.makeBuilder()
            .withArena(["c1", "c2"])
            .withDeck(["c3"])
            .build()

        // When
        let action = GameAction.putBack
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.deck, ["c1", "c2", "c3"])
        XCTAssertEqual(result.arena, [])
    }
}
