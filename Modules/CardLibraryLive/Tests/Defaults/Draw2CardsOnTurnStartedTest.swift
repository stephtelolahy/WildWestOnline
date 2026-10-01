//
//  Draw2CardsOnTurnStartedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct Draw2CardsOnTurnStartedTest {
    @Test func startTurn_shouldDraw2Cards() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1")
            .withDeck(["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state)

        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
