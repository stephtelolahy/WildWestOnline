//
//  StagecoachTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Testing
import GameCore

struct StagecoachTest {
    @Test func play_shouldDraw2Cards() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.stagecoach])
            .withDeck(["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.stagecoach, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.stagecoach, player: "p1"),
            .play(.stagecoach, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
