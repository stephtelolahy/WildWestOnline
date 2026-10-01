//
//  DiscardAllCardsOnEliminatedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct DiscardAllCardsOnEliminatedTest {
    @Test func beingEliminated_havingCards_shouldDiscardAllCards() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withDummyCards(["c2"])
            .withPlayer("p1", hand: ["c1"], inPlay: ["c2"])
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.eliminate(player: "p1"), state: state)

        #expect(result == [
            .eliminate(player: "p1"),
            .discardInPlay("c2", player: "p1"),
            .discardHand("c1", player: "p1")
        ])
    }
}
