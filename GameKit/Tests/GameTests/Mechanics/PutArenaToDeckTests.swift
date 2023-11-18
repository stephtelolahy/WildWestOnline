//
//  PutArenaToDeckTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import Game
import XCTest

final class PutArenaToDeckTests: XCTestCase {
    func test_putArenaToDeck_withArenaSingleCard_shouldMoveCardFromArenaToTopDeck() throws {
        // Given
        let state = GameState.makeBuilder()
            .withArena(["c1"])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.putArenaToDeck
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.deck.cards, ["c1", "c2"])
        XCTAssertNil(result.arena)
    }

    func test_putArenaToDeck_withArenaMultipleCards_shouldMoveCardsFromArenaToTopDeck() throws {
        // Given
        let state = GameState.makeBuilder()
            .withArena(["c1", "c2"])
            .withDeck(["c3"])
            .build()

        // When
        let action = GameAction.putArenaToDeck
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.deck.cards, ["c1", "c2", "c3"])
        XCTAssertNil(result.arena)
    }
}
