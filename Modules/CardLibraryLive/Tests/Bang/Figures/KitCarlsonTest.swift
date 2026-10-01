//
//  KitCarlsonTest.swift
//
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import GameCore
import Testing

struct KitCarlsonTest {
    @Test func startingTurn_shouldChooseDeckCards() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.kitCarlson])
            .withDeck(["c1", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state)

        #expect(result == [
            .startTurn(player: "p1"),
            .discover(),
            .discover(),
            .discover(),
            .choose("c1", player: "p1"),
            .drawDiscovered("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .drawDiscovered("c2", player: "p1"),
            .undiscover()
        ])
    }
}
