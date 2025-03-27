//
//  ElGringoSpec.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

import GameCore
import Testing

struct ElGringoTests {
    @Test(.disabled()) func elGringoDamaged_withOffenderHavingHandCards_shouldStealHandCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHand([.bang, "c2"])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withTurn("p2")
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p2")
        let result = try awaitAction(action, state: state, choose: ["p1", "hiddenHand-0"])

        // Then
        #expect(result == [
            .play(.bang, actor: "p2"),
            .chooseOne(.target, options: ["p1"], player: "p2"),
            .damage(1, player: "p1"),
            .chooseOne(.cardToSteal, options: ["hiddenHand-0"], player: "p1"),
            .stealHand("c2", target: "p2", player: "p1")
        ])
    }

    @Test(.disabled()) func elGringoDamaged_withOffenderHavingNoCard_shouldDoNothing() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withTurn("p2")
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p2")
        let result = try awaitAction(action, state: state, choose: ["p1"])

        // Then
        #expect(result == [
            .play(.bang, actor: "p2"),
            .chooseOne(.target, options: ["p1"], player: "p2"),
            .damage(1, player: "p1")
        ])
    }

    @Test(.disabled()) func elGringoDamaged_withOffenderIsHimself_shouldDoNothing() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.elGringo])
                    .withHealth(3)
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
