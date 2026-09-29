//
//  DocHolydayTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct DocHolydayTest {
    @Test func playing_shouldDiscardTwoCardsAndShoot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.docHolyday])
                    .withHand(["c1", "c2"])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.docHolyday, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.docHolyday, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .choose("p2", player: "p1"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func playing_alreadyUsedThisTurn_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.docHolyday])
                    .withHand(["c1", "c2"])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .withEvents([
                .preparePlay(.docHolyday, player: "p1")
            ])
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.docHolyday, player: "p1")
        await #expect(throws: GameFeature.Error.noReq(.useLimit(1))) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
