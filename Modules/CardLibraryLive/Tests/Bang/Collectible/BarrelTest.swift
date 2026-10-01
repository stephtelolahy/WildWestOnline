//
//  BarrelTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct BarrelTest {
    @Test func playingBarrel_shouldEquip() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.barrel])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.barrel, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.barrel, player: "p1"),
            .equip(.barrel, player: "p1")
        ])
    }

    @Test func triggeringBarrel_oneFlippedCardIsHearts_shouldCancelShot() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", inPlay: [.barrel])
            .withDeck(["c1-2♥️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func triggeringBarrel_oneFlippedCardIsSpades_shouldNotCancelShot() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", inPlay: [.barrel])
            .withDeck(["c1-A♠️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .damage(1, player: "p1")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsWithFirstIsHearts_shouldCancelShot() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.luckyDuke], inPlay: [.barrel])
            .withDeck(["c1-2♥️", "c1-A♠️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .draw(player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsWithSecondIsHearts_shouldCancelShot() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.luckyDuke], inPlay: [.barrel])
            .withDeck(["c1-A♠️", "c1-2♥️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .draw(player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func triggeringBarrel_twoFlippedCardsNoneIsHearts_shouldNotCancelShot() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.luckyDuke], inPlay: [.barrel])
            .withDeck(["c1-A♠️", "c1-2♠️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .draw(player: "p1"),
            .damage(1, player: "p1")
        ])
    }

    @Test func triggeringBarrel_flippedCardIsHearts_holdingMissedCards_shouldNotAskToCounter() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", hand: [.missed], inPlay: [.barrel])
            .withDeck(["c1-2♥️"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .draw(player: "p1"),
            .counterShoot(player: "p1")
        ])
    }
}
