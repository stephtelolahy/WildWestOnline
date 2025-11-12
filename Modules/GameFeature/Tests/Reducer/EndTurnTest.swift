//
//  EndTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//

import Testing
@testable import GameFeature

struct EndTurnTest {
    @Test func endTurn_shouldUnsetTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action.endTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.turn == nil)
    }

    @Test func endTurn_shouldRemovePendingAction() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withQueue(
                [
                    .init(
                        name: .drawDeck,
                        sourcePlayer: "p1",
                        playedCard: "c1"
                    )
                ]
            )
            .build()

        // When
        let action = GameFeature.Action.endTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.queue.isEmpty)
    }
}
