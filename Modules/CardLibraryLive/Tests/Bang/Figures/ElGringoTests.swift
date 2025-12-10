//
//  ElGringoSpec.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

import GameCore
import Testing

struct ElGringoTests {
    @Test func damaged_shouldStealHandCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.elGringo])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1", sourcePlayer: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .stealHand("c2", target: "p2", player: "p1")
        ])
    }

    @Test func damaged_withOffenderHavingNoCard_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.elGringo])
                    .withHealth(3)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1", sourcePlayer: "p2")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }

    @Test func damaged_withOffenderIsHimself_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.elGringo])
                    .withHealth(3)
            }
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1", sourcePlayer: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
