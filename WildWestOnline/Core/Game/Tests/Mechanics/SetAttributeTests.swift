//
//  SetAttributeTests.swift
//
//
//  Created by Hugues Telolahy on 30/08/2023.
//

import GameCore
import Testing

struct SetAttributeTests {
    @Test func setAttribute_shouldSetValue() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        let action = GameAction.setAttribute(.magnifying, value: 1, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").attributes[.magnifying] == 1)
    }

    @Test func removeAttribute_shouldRemoveValue() async throws {
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
        #expect(result.player("p1").attributes[.magnifying] == nil)
    }
}
