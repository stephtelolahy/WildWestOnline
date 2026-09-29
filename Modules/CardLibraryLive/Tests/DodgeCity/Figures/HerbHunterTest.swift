//
//  HerbHunterTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct HerbHunterTest {
    @Test func otherPlayerEliminated_shouldDrawTwoCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.herbHunter])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.eliminate(player: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .eliminate(player: "p2"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
