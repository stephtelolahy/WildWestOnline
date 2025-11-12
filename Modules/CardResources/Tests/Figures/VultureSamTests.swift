//
//  VultureSamTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameFeature
import Testing

struct VultureSamTests {
    @Test func VultureSam_anotherPlayerEliminated_shouldDrawItsCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c2"])
            .withPlayer("p1") {
                $0.withAbilities([.vultureSam])
            }
            .withPlayer("p2") {
                $0.withAbilities([.discardAllCardsOnEliminated])
                    .withHand(["c1"])
                    .withInPlay(["c2"])
            }
            .withPlayer("p3")
            .build()

        // When
        let action = GameFeature.Action.eliminate(player: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p2"),
            .stealInPlay("c2", target: "p2", player: "p1"),
            .stealHand("c1", target: "p2", player: "p1")
        ])
    }
}
