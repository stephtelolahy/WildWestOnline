//
//  QueueTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
import GameCore

struct QueueTest {
    @Test func queue() async throws {
        // Given
        let state = GameState.makeBuilder().build()

        // When
        let action = GameAction.queue([.draw])
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.queue == [.draw])
    }
}
