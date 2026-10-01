//
//  NextTurnOnTurnEndedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct NextTurnOnTurnEndedTest {
    @Test func endturn_shouldStartNextTurn() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1")
            .withPlayer("p2")
            .withTurn("p1")
            .withDeck(["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.endTurn, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .startTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2")
        ])
    }
}
