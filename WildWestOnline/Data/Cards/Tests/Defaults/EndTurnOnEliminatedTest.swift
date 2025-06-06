//
//  EndTurnOnEliminatedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct EndTurnOnEliminatedTest {
    @Test func beingEliminated_currentTurn_shouldNextTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3") {
                $0.withAbilities([.endTurnOnEliminated])
            }
            .withTurn("p3")
            .build()

        // When
        let action = GameFeature.Action.eliminate(player: "p3")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p3"),
            .startTurn(player: "p1")
        ])
    }

    @Test func beingEliminated_currentTurn_withCards_shouldDiscardCardsAndNextTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withDummyCards(["c11", "c12", "c1", "c2"])
            .withPlayer("p1") {
                $0.withHand(["c11"])
                    .withInPlay(["c12"])
                    .withAbilities([.discardAllCardsOnEliminated, .endTurnOnEliminated])
            }
            .withPlayer("p2") {
                $0.withAbilities([.draw2CardsOnTurnStarted])
            }
            .withPlayer("p3")
            .withDeck(["c1", "c2"])
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action.eliminate(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

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
}
