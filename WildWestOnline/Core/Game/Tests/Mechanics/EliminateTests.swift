//
//  EliminateTests.swift
//
//
//  Created by Hugues Telolahy on 05/05/2023.
//

@testable import GameCore
import Testing

struct EliminateTests {
    @Test func eliminatePlayer_shouldRemoveFromPlayOrder() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.playOrder == ["p2"])
    }

    @Test func eliminatePlayer_shouldRemoveSequence() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withSequence(
                [
                    GameAction.prepareAction(
                        .init(
                            action: .drawDeck,
                            card: "c1",
                            actor: "p1"
                        )
                    )
                ]
            )
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.queue.isEmpty)
    }
}
