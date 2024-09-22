//
//  DrawDiscoveredTests.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

import GameCore
import XCTest

final class DrawDiscoveredTests: XCTestCase {
    func test_drawingDiscovered_shouldDrawCard() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscovered(["c1", "c2"])
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDiscovered("c2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.hand["p1"], ["c2"])
        XCTAssertEqual(result.field.discovered, ["c1"])
        XCTAssertEqual(result.field.deck, ["c1"])
    }
}
