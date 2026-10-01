//
//  SeanMalloryTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct SeanMalloryTest {
    @Test func endTurn_holdingLessThanTenCards_shouldNotDiscard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.seanMallory])
                    .withHand(["c1", "c2", "c3", "c4", "c5"])
                    .withHealth(1)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .preparePlay(.endTurn, player: "p1"),
            .endTurn(player: "p1")
        ])
    }

    @Test func endTurn_holdingElevenCards_shouldDiscardOneCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.seanMallory])
                    .withHand(["c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "c11"])
                    .withHealth(3)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .preparePlay(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1")
        ])
    }
}
