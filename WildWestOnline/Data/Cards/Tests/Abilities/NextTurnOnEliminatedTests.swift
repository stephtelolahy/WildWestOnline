//
//  NextTurnOnEliminatedTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct NextTurnOnEliminatedTests {
    /*
    @Test func beingEliminated_currentTurn_shouldNextTurn() async throws {
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
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p3"),
            .startTurn(player: "p1")
        ])
    }

    @Test func beingEliminated_currentTurn_withCards_shouldDiscardCardsAndNextTurn() async throws {
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
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p1"),
            .discardInPlay("c12", player: "p1"),
            .discardHand("c11", player: "p1"),
            .startTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2")
        ])
    }
     */
}
