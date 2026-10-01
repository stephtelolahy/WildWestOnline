//
//  WellsFargoTest.swift
//
//  Created by Hugues Telolahy on 30/10/2024.
//

import Testing
import GameCore

struct WellsFargoTest {
    @Test func play_shouldDraw3Cards() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.wellsFargo])
            .withPlayer("p2")
            .withDeck(["c1", "c2", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.wellsFargo, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.wellsFargo, player: "p1"),
            .play(.wellsFargo, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
