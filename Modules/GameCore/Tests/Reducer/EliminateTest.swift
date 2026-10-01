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
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.eliminate(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.playOrder == ["p2"])
    }

    @Test func eliminate_shouldRemovePendingAction() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withQueue(
                [
                    .init(
                        name: .drawDeck,
                        sourcePlayer: "p1"
                    )
                ]
            )
            .build()

        // When
        let action = GameFeature.Action.eliminate(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.queue.isEmpty)
    }
}
