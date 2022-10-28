//
//  SetupTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import XCTest
import CardGameCore

class SetupTests: XCTestCase {
    
    func test_EachPlayerHasMaxHealthAndHand_IfSetup() {
        // Given
        let deck = Array(1...80).map { Card(id: "c\($0)") }.shuffled()
        let inner = [Card(id: "f1")]
        
        // When
        let state = Setup.buildGame(playersCount: 2, deck: deck, inner: inner)
        
        // Assert
        XCTAssertEqual(state.players.count, 2)
        XCTAssertEqual(state.playOrder, ["p1", "p2"])
        XCTAssertEqual(state.deck.count, 72) // 80 - 2x4
        XCTAssertEqual(state.turn, "p1")
        XCTAssertEqual(state.phase, 1)
        
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
    }
}
