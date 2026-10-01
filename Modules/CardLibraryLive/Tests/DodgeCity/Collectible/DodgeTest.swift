//
//  DodgeTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameCore

struct DodgeTest {
    @Test func beingShot_discardingDodge_shouldCounterAndDrawCard() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", hand: [.dodge])
            .withDeck(["c1"])
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state)

        #expect(result == [
            .shoot("p1"),
            .choose(.dodge, player: "p1"),
            .play(.dodge, player: "p1", target: "p1"),
            .counterShoot(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
