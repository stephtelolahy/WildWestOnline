//
//  ElenaFuenteTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct ElenaFuenteTest {
    @Test func beingShot_holdingAnyCard_shouldCounterWithItAsMissed() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.elenaFuente])
                    .withHand([.beer])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.beer, player: "p1"),
            .play(.beer, player: "p1", target: "p1", alias: .missed),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_holdingMissed_shouldCounterWithoutAlias() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.elenaFuente])
                    .withHand([.missed])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.missed, player: "p1"),
            .play(.missed, player: "p1", target: "p1"),
            .counterShoot(player: "p1")
        ])
    }
}
