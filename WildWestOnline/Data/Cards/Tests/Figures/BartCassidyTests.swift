//
//  BartCassidyTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct BartCassidyTests {
    @Test func BartCassidyBeingDamaged_1LifePoint_shouldDrawACard() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.bartCassidy])
                    .withHealth(3)
            }
            .withDeck(["c1"])
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func BartCassidyBeingDamaged_2LifePoints_shouldDraw2Cards() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.bartCassidy])
                    .withHealth(3)
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.damage(2, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .damage(2, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func BartCassidyBeingDamaged_Lethal_shouldDoNothing() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.bartCassidy])
                    .withHealth(1)
            }
            .withDeck(["c1"])
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
