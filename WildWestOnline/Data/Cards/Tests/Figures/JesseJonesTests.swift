//
//  JesseJonesTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

import CardsData
import GameCore
import XCTest

final class JesseJonesTests: XCTestCase {
    /*
    func test_jesseJonesStartTurn_withNonEmptyDiscard_shouldDrawFirstCardFromDiscard() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.jesseJones])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDiscard(["c1"])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .startTurn(player: "p1"),
            .drawDiscard(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_jesseJonesStartTurn_withEmptyDiscard_shouldDrawCardsFromDeck() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.jesseJones])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
     */
}
