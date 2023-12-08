//
//  DrawSpec.swift
//
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Game
import XCTest

final class DrawDeckTests: XCTestCase {
    func test_drawDeck_whithNonEmptyDeck_shouldRemoveTopCard() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDeck(player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").hand, ["c1"])
        XCTAssertEqual(result.deck.top, "c2")
    }

    func test_drawDeck_whitEmptyDeckAndEnoughDiscardPile_shouldResetDeck() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDeck(player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertNil(result.deck.top)
        XCTAssertEqual(result.discard.top, "c1")
        XCTAssertEqual(result.player("p1").hand, ["c2"])
    }

    func test_drawDeck_whitEmptyDeckAndNotEnoughDiscardPile_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        let action = GameAction.drawDeck(player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.error, .deckIsEmpty)
    }
}
