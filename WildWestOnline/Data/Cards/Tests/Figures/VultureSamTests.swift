//
//  VultureSamTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct VultureSamTests {
    @Test func VultureSam_anotherPlayerEliminated_shouldDrawItsCard() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
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
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p2"),
            .stealInPlay("c2", target: "p2", player: "p1"),
            .stealHand("c1", target: "p2", player: "p1")
        ])
    }
}
