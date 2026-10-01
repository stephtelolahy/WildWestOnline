//
//  EndGameOnEliminatedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct EndGameOnEliminatedTest {
    @Test func game_withOnePlayerLast_shouldBeOver() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        let result = try await dispatchUntilCompleted(.eliminate(player: "p2"), state: state)

        #expect(result == [
            .eliminate(player: "p2"),
            .endGame()
        ])
    }

    @Test func game_with2Players_shouldNotBeOver() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.eliminate(player: "p3"), state: state, ignoreError: true)

        #expect(result == [
            .eliminate(player: "p3")
        ])
    }
}
