//
//  BlackJackTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 10/11/2023.
//
// swiftlint:disable no_magic_numbers

import Game
import Inventory
import XCTest

final class BlackJackTests: XCTestCase {
    func test_blackJack_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.blackJack], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.blackJack)

        // Then
        XCTAssertNil(player.attributes[.drawOnSetTurn])
    }

    func test_blackJackStartTurn_withSecondDrawnCardRed_ShouldDrawAnotherCard() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.blackJack: 0, .startTurnCards: 2])
            }
            .withDeck(["c1", "c2-8♥️", "c3"])
            .build()

        // When
        let action = GameAction.setTurn("p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn("p1"),
            .drawDeck(player: "p1"),
            .drawDeckReveal("c2-8♥️", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_blackJackStartTurn_withSecondDrawnCardBlack_ShouldDoNothing() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.blackJack: 0, .startTurnCards: 2])
            }
            .withDeck(["c1", "c2-A♠️"])
            .build()

        // When
        let action = GameAction.setTurn("p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn("p1"),
            .drawDeck(player: "p1"),
            .drawDeckReveal("c2-A♠️", player: "p1")
        ])
    }
}
