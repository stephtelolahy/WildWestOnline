//
//  DiscardCardsOnEliminatedTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct DiscardCardsOnEliminatedTests {
    @Test func beingEliminated_havingCards_shouldDiscardAllCards() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand(["c1"])
                    .withInPlay(["c2"])
                    .withAbilities([.discardCardsOnEliminated])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p1"),
            .discardInPlay("c2", player: "p1"),
            .discardHand("c1", player: "p1")
        ])
    }
}
