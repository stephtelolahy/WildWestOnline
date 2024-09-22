//
//  DiscoverTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import GameCore
import XCTest

final class DiscoverTests: XCTestCase {
    func test_discover_shouldAddCardToDiscovered() throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.discover(2)
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.discovered, ["c1", "c2"])
        XCTAssertEqual(result.field.deck, ["c1", "c2", "c3"])
    }

    func test_discover_emptyDeck_shouldResetDeck() throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck([])
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameAction.discover(1)
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.discovered, ["c2"])
        XCTAssertEqual(result.field.deck, ["c2"])
        XCTAssertEqual(result.field.discard, ["c1"])
    }
}
