//
//  DrawDiscardTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

import GameCore
import XCTest

final class DrawDiscardTests: XCTestCase {
    func test_drawDiscard_whithNonEmptyDiscard_shouldRemoveTopCard() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDiscard(player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.hand["p1"], ["c1"])
        XCTAssertEqual(result.field.discard, ["c2"])
    }

    func test_drawDiscard_whitEmptyDiscard_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        let action = GameAction.drawDiscard(player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.error, .discardIsEmpty)
    }
}
