//
//  DrawArenaTests.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

import GameCore
import XCTest

final class DrawArenaTests: XCTestCase {
    func test_drawingArena_shouldDrawCard() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withArena(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawArena("c1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").hand, ["c1"])
        XCTAssertEqual(result.arena, ["c2"])
    }
}
