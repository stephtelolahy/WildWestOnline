//
//  LuckTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

import Game
import XCTest

final class LuckTests: XCTestCase {
    func test_luck_shouldDoNothing() {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c2", "c3"])
            .withDiscard(["c1"])
            .build()

        // When
        let action = GameAction.luck("c1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result, state)
    }
}
