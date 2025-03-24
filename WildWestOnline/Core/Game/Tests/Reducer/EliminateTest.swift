//
//  EliminateTest.swift
//
//
//  Created by Hugues Telolahy on 05/05/2023.
//

import Testing
@testable import GameCore

struct EliminateTest {
    @Test func eliminate_shouldRemoveFromPlayOrder() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try await dispatch(action, state: state)

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
                        name: .drawDeck,
                        payload: .init(actor: "p1", played: "")
                    )
                ]
            )
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.queue.isEmpty)
    }
}
