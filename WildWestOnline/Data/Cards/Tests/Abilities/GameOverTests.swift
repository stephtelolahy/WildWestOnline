//
//  GameOverTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct GameOverTests {
    @Test func game_withOnePlayerLast_shouldBeOver() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.eliminate(player: "p2")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p2"),
            .endGame(winner: "p1")
        ])
    }

    @Test func game_with2Players_shouldNotBeOver() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.eliminate(player: "p3")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p3")
        ])
    }

    @Test func dispatchAction_withGameOver_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withWinner("p1")
            .build()

        // When
        // Then
        let action = GameAction.preparePlay("c1", player: "p1")
        await #expect(throws: SequenceState.Error.gameIsOver) {
            try await dispatch(action, state: state)
        }
    }
}
