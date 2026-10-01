//
//  JoseDelgadoTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct JoseDelgadoTest {
    @Test func playing_withBlueCard_shouldDiscardItAndDrawTwoCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.joseDelgado])
                    .withHand([.bang, .mustang])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.joseDelgado, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.joseDelgado, player: "p1"),
            .choose(.mustang, player: "p1"),
            .discardHand(.mustang, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func playing_withoutBlueCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.joseDelgado])
                    .withHand([.bang])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.joseDelgado, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.isBlue], player: "p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func playing_alreadyUsedTwiceThisTurn_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.joseDelgado])
                    .withHand([.mustang])
            }
            .withDeck(["c1", "c2"])
            .withEvents([
                .preparePlay(.joseDelgado, player: "p1"),
                .preparePlay(.joseDelgado, player: "p1")
            ])
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.joseDelgado, player: "p1")
        await #expect(throws: GameFeature.Error.noReq(.useLimit(2))) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
