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
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.eliminate(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playOrder == ["p2"])
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
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.eliminate(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.queue.isEmpty)
    }
}
