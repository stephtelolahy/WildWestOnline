//
//  LuckyDukeTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import Testing
import GameCore

struct LuckyDukeTest {
    @Test func drawing_shouldFlipped2Cards() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.luckyDuke])
            .withDeck(["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.draw(player: "p1"), state: state)

        #expect(result == [
            .draw(player: "p1"),
            .draw(player: "p1")
        ])
    }
}
