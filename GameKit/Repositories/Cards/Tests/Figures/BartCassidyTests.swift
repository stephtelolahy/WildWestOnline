//
//  BartCassidyTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class BartCassidyTests: XCTestCase {
    func test_BartCassidyBeingDamaged_1LifePoint_shouldDrawACard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.bartCassidy])
                    .withHealth(3)
            }
            .withDeck(["c1"])
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .damage(1, player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_BartCassidyBeingDamaged_SeveralLifePoints_shouldDrawCards() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.bartCassidy])
                    .withHealth(3)
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.damage(2, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .damage(2, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_BartCassidyBeingDamaged_Lethal_shouldDoNothing() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.bartCassidy])
                    .withHealth(1)
            }
            .withDeck(["c1"])
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .damage(1, player: "p1")
        ])
    }
}
