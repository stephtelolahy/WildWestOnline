//
//  BillNofaceTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct BillNofaceTest {
    @Test func startTurn_withTwoWounds_shouldDrawThreeCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.billNoface])
                    .withHealth(2)
                    .withMaxHealth(4)
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

    @Test func startTurn_withoutWound_shouldDrawOneCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.billNoface])
                    .withHealth(4)
                    .withMaxHealth(4)
            }
            .withDeck(["c1", "c2", "c3", "c4"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
