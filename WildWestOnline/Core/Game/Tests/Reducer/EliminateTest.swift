//
//  EliminateTest.swift
//
//
//  Created by Hugues Telolahy on 05/05/2023.
//

import Testing
import GameCore

struct EliminateTest {
    @Test func eliminate_shouldRemoveFromPlayOrder() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.playOrder == ["p2"])
    }

    @Test func eliminate_shouldRemovePendingAction() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withQueue(
                [
                    .init(
                        kind: .drawDeck,
                        payload: .init(actor: "p1")
                    )
                ]
            )
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.queue.isEmpty)
    }
}
