//
//  GameOverTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class GameOverTests: XCTestCase {
    func test_game_withOnePlayerLast_shouldBeOver() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.eliminate(player: "p2")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .eliminate(player: "p2"),
            .setGameOver(winner: "p1")
        ])
    }

    func test_game_with2Players_shouldNotBeOver() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.eliminate(player: "p3")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .eliminate(player: "p3")
        ])
    }

    func test_dispatchAction_withGameOver_shouldThrowError() {
        // Given
        let state = GameState.makeBuilder()
            .withWinner("p1")
            .build()

        // When
        let action = GameAction.play("c1", player: "p1")
        let (_, error) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .gameIsOver)
    }
}
