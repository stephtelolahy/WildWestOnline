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
        let action = GameAction.setAttribute(.scope, value: 1, player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.player("p1").attributes[.scope], 1)
    }

    func test_removeAttribute_shouldRemoveValue() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withAttributes([.scope: 1])
            }
            .build()

        // When
        let action = GameAction.removeAttribute(.scope, player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertNil(result.player("p1").attributes[.scope])
    }
}
