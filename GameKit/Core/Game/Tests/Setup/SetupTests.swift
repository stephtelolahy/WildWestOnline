//
//  SetupTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class SetupTests: XCTestCase {
    func test_setupDeck_shouldCreateCardsByCombiningNameAndValues() {
        // Given
        let cardSets: [String: [String]] = [
            "card1": ["val11", "val12"],
            "card2": ["val21", "val22"]
        ]

        // When
        let deck = Setup.buildDeck(cardSets: cardSets)

        // Then
        XCTAssertTrue(deck.contains("card1-val11"))
        XCTAssertTrue(deck.contains("card1-val12"))
        XCTAssertTrue(deck.contains("card2-val21"))
        XCTAssertTrue(deck.contains("card2-val22"))
    }

    func test_setupGame_shouldCreatePlayer() {
        // Given
        let deck = Array(1...80).map { "c\($0)" }
        let figures = ["p1", "p2"]
        let cardRef: [String: Card] = [
            "p1": Card("p1", attributes: [.maxHealth: 4, .magnifying: 1]),
            "p2": Card("p2", attributes: [.maxHealth: 3, .remoteness: 1])
        ]

        // When
        let state = Setup.buildGame(
            figures: figures,
            deck: deck,
            cardRef: cardRef
        )

        // Then
        // should create a game with given player number
        XCTAssertEqual(state.players.count, 2)
        XCTAssertTrue(state.playOrder.contains(["p1", "p2"]))
        XCTAssertTrue(state.startOrder.contains(["p1", "p2"]))

        // should set players to max health
        XCTAssertEqual(state.player("p1").health, 4)
        XCTAssertEqual(state.player("p2").health, 3)

        // should set players hand cards to health
        XCTAssertEqual(state.player("p1").hand.count, 4)
        XCTAssertEqual(state.player("p2").hand.count, 3)
        XCTAssertEqual(state.deck.count, 73)
        XCTAssertEqual(state.discard, [])

        // should set undefined turn
        XCTAssertNil(state.turn)

        // should set figure attributes
        XCTAssertEqual(state.player("p1").abilities, ["p1"])
        XCTAssertEqual(state.player("p1").attributes[.magnifying], 1)
        XCTAssertEqual(state.player("p1").attributes[.maxHealth], 4)
        XCTAssertEqual(state.player("p2").abilities, ["p2"])
        XCTAssertEqual(state.player("p2").attributes[.remoteness], 1)
        XCTAssertEqual(state.player("p2").attributes[.maxHealth], 3)
    }
}
