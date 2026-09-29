//
//  PixiePeteTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct PixiePeteTest {
    @Test func startTurn_shouldDrawThreeCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.pixiePete])
            }
            .withDeck(["c1", "c2", "c3", "c4"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
