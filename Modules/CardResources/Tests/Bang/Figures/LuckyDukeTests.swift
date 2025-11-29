//
//  LuckyDukeTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import Testing
import GameFeature
import CardResources

struct LuckyDukeTests {
    @Test func drawing_shouldFlipped2Cards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.luckyDuke])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.draw(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .draw(player: "p1"),
            .draw(player: "p1")
        ])
    }
}
