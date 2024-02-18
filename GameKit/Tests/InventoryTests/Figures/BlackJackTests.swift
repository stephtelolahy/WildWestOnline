//
//  BlackJackTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 10/11/2023.
//
// swiftlint:disable no_magic_numbers

import GameCore
import Inventory
import XCTest

final class BlackJackTests: XCTestCase {
    func test_blackJack_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.blackJack], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.blackJack)

        // Then
        XCTAssertFalse(player.abilities.contains(.drawOnSetTurn))
    }

    func test_blackJackStartTurn_withSecondDrawnCardRed_shouldDrawAnotherCard() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.blackJack])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2-8♥️", "c3"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .revealHand("c2-8♥️", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_blackJackStartTurn_withSecondDrawnCardBlack_shouldDoNothing() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.blackJack])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2-A♠️"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .revealHand("c2-A♠️", player: "p1")
        ])
    }
}
