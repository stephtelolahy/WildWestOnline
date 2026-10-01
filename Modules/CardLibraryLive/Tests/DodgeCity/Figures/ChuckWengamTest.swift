//
//  ChuckWengamTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct ChuckWengamTest {
    @Test func playing_shouldLoseOneLifePointAndDrawTwoCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.chuckWengam])
                    .withHealth(3)
                    .withMaxHealth(4)
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.chuckWengam, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.chuckWengam, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .damage(1, player: "p1")
        ])
    }

    @Test func playing_withLastLifePoint_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.chuckWengam])
                    .withHealth(1)
                    .withMaxHealth(4)
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.chuckWengam, player: "p1")
        await #expect(throws: GameFeature.Error.noReq(.healthAtLeast(2))) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
