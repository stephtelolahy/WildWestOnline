//
//  BartCassidyTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameFeature
import Testing

struct BartCassidyTests {
    @Test func BartCassidyBeingDamaged_1LifePoint_shouldDrawACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.bartCassidy])
                    .withHealth(3)
            }
            .withDeck(["c1"])
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func BartCassidyBeingDamaged_2LifePoints_shouldDraw2Cards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.bartCassidy])
                    .withHealth(3)
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.damage(2, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(2, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func BartCassidyBeingDamaged_Lethal_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.bartCassidy])
                    .withHealth(1)
            }
            .withDeck(["c1"])
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
