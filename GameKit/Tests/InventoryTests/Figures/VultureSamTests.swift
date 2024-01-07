//
//  VultureSamTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class VultureSamTests: XCTestCase {
    func test_VultureSam_anotherPlayerEliminated_shouldDrawItsCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.vultureSam])
            }
            .withPlayer("p2") {
                $0.withAbilities([.discardCardsOnEliminated])
                    .withHand(["c1"])
                    .withInPlay(["c2"])
            }
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.eliminate(player: "p2")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .eliminate(player: "p2"),
            .drawInPlay("c2", target: "p2", player: "p1"),
            .drawHand("c1", target: "p2", player: "p1")
        ])
    }
}
