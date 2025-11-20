//
//  DiscardExcessHandOnTurnEndedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct DiscardExcessHandOnTurnEndedTest {
    @Test func endTurn_oneExcessCard_shouldDiscardAHandCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
                    .withHealth(2)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .endTurn(player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1")
        ])
    }

    @Test func endTurn_twoExcessCard_shouldDiscardTwoHandCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
                    .withHealth(1)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .endTurn(player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1")
        ])
    }

    @Test func endTurn_noExcessCards_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
                    .withHealth(3)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .endTurn(player: "p1")
        ])
    }

    @Test func endTurn_customHandLimit_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
                    .withHealth(1)
                    .withHandLimit(10)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .endTurn(player: "p1")
        ])
    }
}
