//
//  BlackJackTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 10/11/2023.
//

import CardsData
import GameCore
import XCTest

final class BlackJackTests: XCTestCase {
    func test_blackJack_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.blackJack], deck: [], cards: Cards.all)

        // When
        let player = state.player(.blackJack)

        // Then
        XCTAssertFalse(player.abilities.contains(.drawOnStartTurn))
    }

    func test_blackJackStartTurn_withSecondDrawnCardRed_shouldDrawAnotherCard() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.blackJack])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2-8♥️", "c3"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .showHand("c2-8♥️", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_blackJackStartTurn_withSecondDrawnCardBlack_shouldDoNothing() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.blackJack])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2-A♠️"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .showHand("c2-A♠️", player: "p1")
        ])
    }
}
