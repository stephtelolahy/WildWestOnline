//
//  LuckTests.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

// swiftlint:disable: identifier_name

import XCTest
@testable import GameCards
import GameCore

final class LuckTests: XCTestCase {
    
    func test_DiscardTopDeckCard_OnLuck() throws {
        // Given
        let c1 = CardImpl(id: "c1", value: "9♠️")
        let ctx: Game = GameImpl(deck: [c1])
        let sut = Luck(regex: "regex")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.deck.map(\.id), [])
            XCTAssertEqual(ctx.discard.map(\.id), ["c1"])
        }
    }
    
    // TODO: test_FlipTwoCards_IfHavingAttribute
    
    // TODO: test_ApplySuccess_IfFirstFlipCardMatches()
    
    // TODO: test_ApplySuccess_IfSecondFlipCardMatches()
}
