//
//  UndiscoverTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import GameCore
import Testing

struct UndiscoverTests {
    @Test func undiscover_shouldHideCards() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDiscovered(["c2"])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.undiscover
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.discovered.isEmpty)
        #expect(result.field.deck == ["c2"])
    }
}
