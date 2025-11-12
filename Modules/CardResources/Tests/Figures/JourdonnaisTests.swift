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
                $0.withAbilities([.jourdonnais])
                    .withCardsPerDraw(1)
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

    @Test func beingShot_flippedCardIsHearts_shouldOnlyTriggerBarrel() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([
                    .jourdonnais,
                    .discardMissedOnShot
                ])
                .withCardsPerDraw(1)
                .withInPlay([.barrel])
                .withHand([.missed])
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

    @Test func beingShot_flippedCardsAreNotHearts_shouldAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([
                    .jourdonnais,
                    .discardMissedOnShot
                ])
                .withCardsPerDraw(1)
                .withInPlay([.barrel])
                .withHand([.missed])
            }
            .withDeck(["c1-2♠️", "c1-3♣️"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let choices: [Choice] = [
            .init(options: [.missed, .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

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
