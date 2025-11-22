//
//  JourdonnaisTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameFeature
import Testing

struct JourdonnaisTests {
    @Test func beingShot_flippedCardIsHearts_shouldCounterShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.jourdonnais])
                    .withAttr(.cardsPerDraw, 1)
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)


        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_firstFlippedCardIsHearts_shouldOnlyTriggerBarrel() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.jourdonnais])
                .withAttr(.cardsPerDraw, 1)
                .withInPlay([.barrel])
                .withHand([.missed])
            }
            .withDeck(["c1-2♥️", "c3"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_secondFlippedCardIsHearts_shouldTriggerBarrelAndAbility() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.jourdonnais])
                .withAttr(.cardsPerDraw, 1)
                .withInPlay([.barrel])
                .withHand([.missed])
            }
            .withDeck(["c1-2♠️", "c1-3♥️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .draw(),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_flippedCardsAreNotHearts_shouldAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.jourdonnais])
                .withAttr(.cardsPerDraw, 1)
                .withInPlay([.barrel])
                .withHand([.missed])
            }
            .withDeck(["c1-2♠️", "c1-3♣️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .draw(),
            .draw(),
            .choose(.missed, player: "p1"),
            .discardHand(.missed, player: "p1"),
            .counterShoot(player: "p1")
        ])
    }
}
