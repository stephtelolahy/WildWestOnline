//
//  UndiscoverTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import GameCore
import XCTest

final class UndiscoverTests: XCTestCase {
    func test_undiscover_shouldHideCards() throws {
        // Given
        let state = GameState.makeBuilder()
            .withDiscovered(["c2"])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.undiscover
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.field.discovered, [])
        XCTAssertEqual(result.field.deck, ["c2"])
    }
}
