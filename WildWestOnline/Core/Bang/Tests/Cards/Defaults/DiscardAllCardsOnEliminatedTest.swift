//
//  DiscardAllCardsOnEliminatedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

struct DiscardAllCardsOnEliminatedTest {
    @Test func beingEliminated_havingCards_shouldDiscardAllCards() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1"])
                    .withInPlay(["c2"])
                    .withAbilities([.defaultDiscardAllCardsOnEliminated])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p1"),
            .discard("c2", player: "p1"),
            .discard("c1", player: "p1")
        ])
    }
}
