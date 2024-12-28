//
//  EndGameOnEliminatedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct EndGameOnEliminatedTest {
    @Test func game_withOnePlayerLast_shouldBeOver() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withAbilities([.defaultEndGameOnEliminated])
            }
            .build()

        // When
        let action = GameAction.eliminate(player: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p2"),
            .endGame(player: "p2")
        ])
    }

    @Test func game_with2Players_shouldNotBeOver() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3") {
                $0.withAbilities([.defaultEndGameOnEliminated])
            }
            .build()

        // When
        let action = GameAction.eliminate(player: "p3")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p3")
        ])
    }
}
