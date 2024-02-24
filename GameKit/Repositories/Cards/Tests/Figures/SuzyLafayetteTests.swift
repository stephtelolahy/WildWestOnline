//
//  SuzyLafayetteTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class SuzyLafayetteTests: XCTestCase {
    func test_SuzyLafayette_havingNoHandCards_shouldDrawACard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1"])
            }
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.discardHand("c1", player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardHand("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_SuzyLafayette_havingSomeHandCards_shouldDoNothing() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.discardHand("c1", player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardHand("c1", player: "p1")
        ])
    }
}
