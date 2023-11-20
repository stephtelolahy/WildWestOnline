//
//  JesseJonesTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//
// swiftlint:disable no_magic_numbers

import Game
import Inventory
import XCTest

final class JesseJonesTests: XCTestCase {
    func test_jesseJones_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.jesseJones], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.jesseJones)

        // Then
        XCTAssertNil(player.attributes[.drawOnSetTurn])
    }

    func test_jesseJonesStartTurn_withNonEmptyDiscard_shouldDrawFirstCardFromDiscard() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.jesseJones: 0, .startTurnCards: 2])
            }
            .withDiscard(["c1"])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.setTurn("p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn("p1"),
            .drawDiscard(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_jesseJonesStartTurn_withEmptyDiscard_shouldDrawCardsFromDeck() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.jesseJones: 0, .startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.setTurn("p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn("p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
