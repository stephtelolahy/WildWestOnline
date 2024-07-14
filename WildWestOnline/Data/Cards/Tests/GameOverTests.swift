//
//  GameOverTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class GameOverTests: XCTestCase {
    func test_game_withOnePlayerLast_shouldBeOver() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.eliminate(player: "p2")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .eliminate(player: "p2"),
            .setGameOver(winner: "p1")
        ])
    }

    func test_game_with2Players_shouldNotBeOver() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.eliminate(player: "p3")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .eliminate(player: "p3")
        ])
    }

    func test_dispatchAction_withGameOver_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilder()
            .withWinner("p1")
            .build()

        // When
        // Then
        let action = GameAction.play("c1", player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? SequenceState.Error, .gameIsOver)
        }
    }
}
