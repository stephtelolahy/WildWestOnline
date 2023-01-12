//
//  DiscardTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class DiscardTests: XCTestCase {

    func test_DiscardHandCard() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(hand: [c1, c2, c3])
        let ctx = GameImpl(players: ["p1": p1])
        let sut = Discard(player: .id("p1"), card: .id("c2"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), ["c1", "c3"])
            XCTAssertEqual(ctx.discard.map(\.id), ["c2"])
        }
    }

}
