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
    
    func test_EachPlayerHasMaxHealthAndHandCards_IfSetup() {
        // Given
        let deck = Array(1...80).map { CardImpl(id: "c\($0)") }.shuffled()
        let abilities = [CardImpl(name: "a1")]
        
        // When
        let ctx = sut.createGame(playersCount: 2,
                                 deck: deck,
                                 abilities: abilities)
        
        // Assert
        XCTAssertEqual(ctx.players.count, 2)
        XCTAssertEqual(ctx.playOrder, ["p1", "p2"])
        XCTAssertEqual(ctx.deck.count, 72) // 80 - 2x4
        XCTAssertNil(ctx.turn)
        
        XCTAssertEqual(ctx.player("p1").maxHealth, 4)
        XCTAssertEqual(ctx.player("p1").health, 4)
        XCTAssertEqual(ctx.player("p1").hand.count, 4)
        XCTAssertEqual(ctx.player("p1").abilities.map(\.id), ["a1"])
        
        XCTAssertEqual(ctx.player("p2").maxHealth, 4)
        XCTAssertEqual(ctx.player("p2").health, 4)
        XCTAssertEqual(ctx.player("p2").hand.count, 4)
        XCTAssertEqual(ctx.player("p2").abilities.map(\.id), ["a1"])
    }
    
}
