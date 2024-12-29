//
//  BartCassidyTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class BartCassidyTests: XCTestCase {
    func test_BartCassidyBeingDamaged_1LifePoint_shouldDrawACard() throws {
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
        let result = try awaitAction(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_BartCassidyBeingDamaged_2LifePoints_shouldDraw2Cards() throws {
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
        let result = try awaitAction(action, state: state)

        // Then
        #expect(result == [
            .damage(2, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_BartCassidyBeingDamaged_Lethal_shouldDoNothing() throws {
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
        let result = try awaitAction(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
