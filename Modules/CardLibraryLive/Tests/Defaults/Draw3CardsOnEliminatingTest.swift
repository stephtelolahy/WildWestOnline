//
//  Draw3CardsOnEliminatingTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2025.
//

import Testing
import GameCore

struct Draw3CardsOnEliminatingTest {
    @Test func eliminating_shouldDraw2Cards() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1")
            .withPlayer("p2", health: 1)
            .withPlayer("p3")
            .withDeck(["c1", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p2", sourcePlayer: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .damage(1, player: "p2"),
            .eliminate(player: "p2"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func eliminated_withOffenderIsHimself_shouldDoNoting() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 1)
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1", sourcePlayer: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .damage(1, player: "p1"),
            .eliminate(player: "p1")
        ])
    }
}
