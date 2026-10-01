//
//  DynamiteTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct DynamiteTest {
    @Test func play_shouldEquip() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.dynamite])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.dynamite, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.dynamite, player: "p1"),
            .equip(.dynamite, player: "p1")
        ])
    }

    @Test func triggering_withFlippedCardIsHearts_shouldPassInPlay() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", inPlay: [.dynamite])
            .withPlayer("p2")
            .withDeck(["c1-9♦️", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state)

        #expect(result == [
            .startTurn(player: "p1"),
            .draw(player: "p1"),
            .passInPlay(.dynamite, target: "p2", player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func triggeringDynamite_withFlippedCardIsSpades_notLethal_shouldApplyDamageAndDiscardCard() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 4, inPlay: [.dynamite])
            .withDeck(["c1-8♠️", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state)

        #expect(result == [
            .startTurn(player: "p1"),
            .draw(player: "p1"),
            .damage(3, player: "p1"),
            .discardInPlay(.dynamite, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func triggeringDynamite_withFlippedCardIsSpades_lethal_shouldEliminate() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withDummyCards(["c4"])
            .withPlayer("p1", health: 3, inPlay: [.dynamite, "c4"])
            .withPlayer("p2")
            .withPlayer("p3")
            .withDeck(["c1-8♠️", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .startTurn(player: "p1"),
            .draw(player: "p1"),
            .damage(3, player: "p1"),
            .eliminate(player: "p1"),
            .discardInPlay(.dynamite, player: "p1"),
            .discardInPlay("c4", player: "p1"),
            .startTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2")
        ])
    }
}
