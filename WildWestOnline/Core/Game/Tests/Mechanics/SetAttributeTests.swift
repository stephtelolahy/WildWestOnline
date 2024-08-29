//
//  SetAttributeTests.swift
//
//
//  Created by Hugues Telolahy on 30/08/2023.
//

import GameCore
import XCTest

final class SetAttributeTests: XCTestCase {
    func test_setAttribute_shouldSetValue() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        let action = GameAction.setAttribute(.magnifying, value: 1, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").attributes[.magnifying], 1)
    }

    func test_removeAttribute_shouldRemoveValue() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withAttributes([.magnifying: 1])
            }
            .build()

        // When
        let action = GameAction.setAttribute(.magnifying, value: nil, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertNil(result.player("p1").attributes[.magnifying])
    }
}
