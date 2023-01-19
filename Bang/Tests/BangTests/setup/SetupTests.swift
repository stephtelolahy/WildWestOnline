//
//  SetupTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

import XCTest
import Bang

final class RuleSetupTests: XCTestCase {
    
    private let sut: Setup = SetupImpl()
    
    func test_EachPlayerHasMaxHealthAndHandCards() throws {
        // Given
        let deck = Array(1...80).map { CardImpl(id: "c\($0)") }.shuffled()
        let abilities = [CardImpl(name: "a1")]
        let figures = Array(1...2).map { CardImpl(name: "p\($0)") }
        
        // When
        let ctx = sut.createGame(playersCount: 2,
                                 deck: deck,
                                 abilities: abilities,
                                 figures: figures)
        
        // Assert
        XCTAssertEqual(ctx.players.count, 2)
        XCTAssertEqual(ctx.playOrder.count, 2)
        XCTAssertEqual(ctx.deck.count, 72) // 80 - 2x4
        XCTAssertNil(ctx.turn)
        
        let player1 = try XCTUnwrap(ctx.player("p1"))
        XCTAssertEqual(player1.maxHealth, 4)
        XCTAssertEqual(player1.health, 4)
        XCTAssertEqual(player1.hand.count, 4)
        XCTAssertEqual(player1.abilities.map(\.id), ["a1"])
        
        let player2 = try XCTUnwrap(ctx.player("p2"))
        XCTAssertEqual(player2.maxHealth, 4)
        XCTAssertEqual(player2.health, 4)
        XCTAssertEqual(player2.hand.count, 4)
        XCTAssertEqual(player2.abilities.map(\.id), ["a1"])
    }
    
}
