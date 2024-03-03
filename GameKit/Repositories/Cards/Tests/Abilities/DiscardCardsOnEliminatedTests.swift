//
//  DiscardCardsOnEliminatedTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class DiscardCardsOnEliminatedTests: XCTestCase {
    func test_beingEliminated_havingCards_shouldDiscardAllCards() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .eliminate(player: "p1"),
            .discardInPlay("c2", player: "p1"),
            .discardHand("c1", player: "p1")
        ])
    }
}
