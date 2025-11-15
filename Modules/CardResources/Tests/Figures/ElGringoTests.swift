//
//  ElGringoSpec.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

import GameFeature
import Testing

struct ElGringoTests {
    @Test func elGringoDamaged_withOffenderHavingHandCards_shouldStealHandCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1", sourcePlayer: "p2")
        let choices: [Choice] = [
            .init(options: ["hiddenHand-0"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .stealHand("c2", target: "p2", player: "p1")
        ])
    }

    @Test func elGringoDamaged_withOffenderHavingNoCard_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
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

    @Test func elGringoDamaged_withOffenderIsHimself_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
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
