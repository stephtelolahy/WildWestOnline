//
//  ElGringoSpec.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

import GameCore
import Testing

struct ElGringoTests {
    @Test func elGringoDamaged_withOffenderHavingHandCards_shouldStealHandCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHand([.bang, "c2"])
                    .withWeapon(1)
                    .withPlayLimitPerTurn([.bang: 1])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p2")
        let choices: [Choice] = [
            .init(options: ["p1"], selectionIndex: 0),
            .init(options: ["hiddenHand-0"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("p1", player: "p2"),
            .play(.bang, player: "p2", target: "p1"),
            .shoot("p1"),
            .damage(1, player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .stealHand("c2", target: "p2", player: "p1")
        ])
    }

    @Test func elGringoDamaged_withOffenderHavingNoCard_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
                    .withWeapon(1)
                    .withPlayLimitPerTurn([.bang: 1])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p2")
        let choices: [Choice] = [
            .init(options: ["p1"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("p1", player: "p2"),
            .play(.bang, player: "p2", target: "p1"),
            .shoot("p1"),
            .damage(1, player: "p1")
        ])
    }

    @Test func elGringoDamaged_withOffenderIsHimself_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
                    .withHealth(3)
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action(name: .damage, sourcePlayer: "p1", targetedPlayer: "p1", amount: 1)
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
