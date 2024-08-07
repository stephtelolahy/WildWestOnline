//
//  NextTurnOnEliminatedTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class NextTurnOnEliminatedTests: XCTestCase {
    func test_beingEliminated_currentTurn_shouldNextTurn() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3") {
                $0.withAbilities([.nextTurnOnEliminated])
            }
            .withTurn("p3")
            .build()

        // When
        let action = GameAction.eliminate(player: "p3")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .eliminate(player: "p3"),
            .startTurn(player: "p1")
        ])
    }

    func test_beingEliminated_currentTurn_withCards_shouldDiscardCardsAndNextTurn() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand(["c11"])
                    .withInPlay(["c12"])
                    .withAbilities([.discardCardsOnEliminated, .nextTurnOnEliminated])
            }
            .withPlayer("p2") {
                $0.withAbilities([.drawOnStartTurn])
                    .withAttributes([.startTurnCards: 2])
            }
            .withPlayer("p3")
            .withDeck(["c1", "c2"])
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .eliminate(player: "p1"),
            .discardInPlay("c12", player: "p1"),
            .discardHand("c11", player: "p1"),
            .startTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2")
        ])
    }
}
