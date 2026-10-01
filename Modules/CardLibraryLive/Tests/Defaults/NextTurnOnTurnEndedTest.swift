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
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1")
            .withPlayer("p2")
            .withTurn("p1")
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .startTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2")
        ])
    }
}
