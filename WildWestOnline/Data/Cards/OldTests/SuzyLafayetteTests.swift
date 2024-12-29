//
//  SuzyLafayetteTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class SuzyLafayetteTests: XCTestCase {
    func test_SuzyLafayette_havingNoHandCards_shouldDrawACard() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1"])
            }
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.discardHand("c1", player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        #expect(result == [
            .discardHand("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_SuzyLafayette_havingSomeHandCards_shouldDoNothing() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.discardHand("c1", player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        #expect(result == [
            .discardHand("c1", player: "p1")
        ])
    }
}
