//
//  DiscoverTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import GameCore
import XCTest

final class DiscoverTests: XCTestCase {
    func test_discover_withEmptyArena_shouldAddCardtoArena() throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.discover
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.arena, ["c1"])
        XCTAssertEqual(result.field.deck, ["c2", "c3"])
    }

    func test_discover_withNonEmptyArena_shouldAddCardtoArena() throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c2", "c3"])
            .withArena(["c1"])
            .build()

        // When
        let action = GameAction.discover
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.arena, ["c1", "c2"])
        XCTAssertEqual(result.field.deck, ["c3"])
    }
}
