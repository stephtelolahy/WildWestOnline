//
//  JailTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct JailTest {
    @Test func playAgainstAnyPlayer_shouldHandicap() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.jail])
            .withPlayer("p2")
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.jail, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.jail, player: "p1"),
            .choose("p2", player: "p1"),
            .handicap(.jail, target: "p2", player: "p1")
        ])
    }

    @Test func triggeringJail_flippedCardIsHearts_shouldEscapeFromJail() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", inPlay: [.jail])
            .withDeck(["c1-2♥️", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state)

        #expect(result == [
            .startTurn(player: "p1"),
            .draw(player: "p1"),
            .discardInPlay(.jail, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func triggeringJail_flippedCardIsNotHearts_shouldSkipTurn() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", inPlay: [.jail])
            .withPlayer("p2")
            .withDeck(["c1-A♠️", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state)

        #expect(result == [
            .startTurn(player: "p1"),
            .draw(player: "p1"),
            .endTurn(player: "p1"),
            .startTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2"),
            .discardInPlay(.jail, player: "p1")
        ])
    }
}
