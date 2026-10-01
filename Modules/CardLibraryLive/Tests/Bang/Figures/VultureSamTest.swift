//
//  VultureSamTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct VultureSamTest {
    @Test func anotherPlayerEliminated_shouldDrawItsCard() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withDummyCards(["c2"])
            .withPlayer("p1", figure: [.vultureSam])
            .withPlayer("p2", hand: ["c1"], inPlay: ["c2"])
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.eliminate(player: "p2"), state: state)

        #expect(result == [
            .eliminate(player: "p2"),
            .stealInPlay("c2", target: "p2", player: "p1"),
            .stealHand("c1", target: "p2", player: "p1")
        ])
    }
}
