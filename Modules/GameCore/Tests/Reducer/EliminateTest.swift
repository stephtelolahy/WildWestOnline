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
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        let result = try await dispatch(.eliminate(player: "p1"), state: state)

        #expect(result.playOrder == ["p2"])
    }

    @Test func eliminate_shouldRemovePendingAction() async throws {
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

        let result = try await dispatch(.eliminate(player: "p1"), state: state)

        #expect(result.queue.isEmpty)
    }
}
