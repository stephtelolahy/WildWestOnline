//
//  NextTurnOnEliminatedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct NextTurnOnEliminatedTest {
    @Test func beingEliminated_currentTurn_shouldNextTurn() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3")
            .withTurn("p3")
            .withDeck(["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.eliminate(player: "p3"), state: state)

        #expect(result == [
            .eliminate(player: "p3"),
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func beingEliminated_currentTurn_withCards_shouldDiscardCardsAndNextTurn() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withDummyCards(["c12"])
            .withPlayer("p1", hand: ["c11"], inPlay: ["c12"])
            .withPlayer("p2")
            .withPlayer("p3")
            .withDeck(["c1", "c2"])
            .withTurn("p1")
            .build()

        let result = try await dispatchUntilCompleted(.eliminate(player: "p1"), state: state)

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
