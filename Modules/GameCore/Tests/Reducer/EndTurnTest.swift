//
//  EndTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//

import Testing
@testable import GameCore

struct EndTurnTest {
    @Test func endTurn_shouldUnsetTurn() async throws {
        let state = GameFeature.State.makeBuilder()
            .withTurn("p1")
            .build()

        let result = try await dispatch(.endTurn(player: "p1"), state: state)

        #expect(result.turn == nil)
    }

    @Test func endTurn_shouldRemovePendingAction() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withQueue(
                [
                    .init(
                        name: .drawDeck,
                        sourcePlayer: "p1",
                        sourceCard: "c1"
                    )
                ]
            )
            .build()

        let result = try await dispatch(.endTurn(player: "p1"), state: state)

        #expect(result.queue.isEmpty)
    }
}
