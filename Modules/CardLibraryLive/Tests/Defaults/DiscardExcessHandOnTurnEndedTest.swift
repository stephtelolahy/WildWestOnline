//
//  DiscardExcessHandOnTurnEndedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct DiscardExcessHandOnTurnEndedTest {
    @Test func endTurn_oneExcessCard_shouldDiscardAHandCard() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 2, hand: ["c1", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.endTurn, player: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .preparePlay(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1")
        ])
    }

    @Test func endTurn_twoExcessCard_shouldDiscardTwoHandCards() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 1, hand: ["c1", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.endTurn, player: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .preparePlay(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1")
        ])
    }

    @Test func endTurn_noExcessCards_shouldDoNothing() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 3, hand: ["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.endTurn, player: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .preparePlay(.endTurn, player: "p1"),
            .endTurn(player: "p1")
        ])
    }
}
