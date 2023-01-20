//
//  StoreTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameRules

final class StoreTests: XCTestCase {

    func test_DrawACardFromDeckToStore() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let ctx = GameImpl(deck: [c1, c2])
        let sut = Store()
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.store.map(\.id), ["c1"])
            XCTAssertEqual(ctx.deck.map(\.id), ["c2"])
        }
    }

}
