//
//  DrawDeckChooseTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import Game
import XCTest

final class DrawDeckChooseTests: XCTestCase {
    func test_drawDeckChoose_shouldDrawSpecifiedCard() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.drawDeckChoose("c2", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").hand.cards, ["c2"])
        XCTAssertEqual(result.deck.cards, ["c1"])
    }
}
