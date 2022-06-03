//
//  SetupTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import XCTest
import CardGameCore

class SetupTests: XCTestCase {

    func test_InitialDeckIsShuffledFromCardSet() throws {
        // Given
        let uniqueCards = [Card(name: "bang"),
                           Card(name: "missed"),
                           Card(name: "beer")]
        let cardSets = ["bang": ["A♠️", "2♦️"],
                        "beer": ["7♥️", "10♥️"],
                        "missed": ["Q♣️"],
                        "indians": ["K♦️"]]
        
        // When
        let deck = Setup.buildDeck(uniqueCards: uniqueCards, cardSets: cardSets)
        
        // Assert
        XCTAssertEqual(deck.count, 5)
        XCTAssertTrue(deck.contains { $0.id == "bang-A♠️" })
        XCTAssertTrue(deck.contains { $0.id == "bang-2♦️" })
        XCTAssertTrue(deck.contains { $0.id == "beer-7♥️" })
        XCTAssertTrue(deck.contains { $0.id == "beer-10♥️" })
        XCTAssertTrue(deck.contains { $0.id == "missed-Q♣️" })
    }
    
    func test_EachPlayerHasMaxHealthAndHand_IfSetup() {
        // Given
        let deck = Array(1...80).map { Card(id: "c\($0)") }.shuffled()
        let inner = [Card(name: "f1")]
        
        // When
        let state = Setup.buildGame(playersCount: 2, deck: deck, inner: inner)
        
        // Assert
        XCTAssertEqual(state.players.count, 2)
        XCTAssertEqual(state.playOrder, ["p1", "p2"])
        XCTAssertEqual(state.player("p1").maxHealth, 4)
        XCTAssertEqual(state.player("p1").health, 4)
        XCTAssertEqual(state.player("p1").hand.count, 4)
        XCTAssertEqual(state.player("p1").inner.count, 1)
        XCTAssertEqual(state.player("p1").inner[0].id, "f1")
        XCTAssertEqual(state.player("p2").maxHealth, 4)
        XCTAssertEqual(state.player("p2").health, 4)
        XCTAssertEqual(state.player("p2").hand.count, 4)
        XCTAssertEqual(state.player("p2").inner.count, 1)
        XCTAssertEqual(state.player("p2").inner[0].id, "f1")
        XCTAssertEqual(state.deck.count, 72) // 80 - 2x4
        XCTAssertEqual(state.turn, "p1")
        XCTAssertEqual(state.turnReady, false)
    }
}
