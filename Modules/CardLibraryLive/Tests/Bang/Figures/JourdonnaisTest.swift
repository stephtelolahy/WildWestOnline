//
//  JourdonnaisTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct JourdonnaisTest {
    @Test func beingShot_flippedCardIsHearts_shouldCounterShot() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.jourdonnais])
            .withDeck(["c1-2♥️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_firstFlippedCardIsHearts_shouldOnlyTriggerBarrel() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.jourdonnais], hand: [.missed], inPlay: [.barrel])
            .withDeck(["c1-2♥️", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_secondFlippedCardIsHearts_shouldTriggerBarrelAndAbility() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.jourdonnais], hand: [.missed], inPlay: [.barrel])
            .withDeck(["c1-2♠️", "c1-3♥️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .draw(player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_flippedCardsAreNotHearts_shouldAskToCounter() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.jourdonnais], hand: [.missed], inPlay: [.barrel])
            .withDeck(["c1-2♠️", "c1-3♣️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .draw(player: "p1"),
            .choose(.missed, player: "p1"),
            .play(.missed, player: "p1", target: "p1"),
            .counterShoot(player: "p1")
        ])
    }
}
