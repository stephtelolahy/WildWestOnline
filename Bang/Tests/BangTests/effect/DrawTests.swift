//
//  DrawTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
import Bang

final class DrawTests: XCTestCase {
    
    func test_DrawACardWhenHandNotEmpty() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           deck: [c2, c3])
        let sut = Draw(player: .id("p1"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.hand.map(\.id), ["c1", "c2"])
            XCTAssertEqual(ctx.deck.map(\.id), ["c3"])
            XCTAssertNil($0.effects)
        }
    }
    
    func test_DrawACardWhenHandEmpty() throws {
        // Given
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1],
                           deck: [c2, c3])
        let sut = Draw(player: .id("p1"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.hand.map(\.id), ["c2"])
            XCTAssertEqual(ctx.deck.map(\.id), ["c3"])
            XCTAssertNil($0.effects)
        }
    }
    
    func test_ResetDeck_IfEmpty() throws {
        // Given
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1],
                           discard: [c2, c3])
        let sut = Draw(player: .id("p1"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.hand.map(\.id), ["c2"])
            XCTAssertEqual(ctx.deck.map(\.id), [])
            XCTAssertEqual(ctx.discard.map(\.id), ["c3"])
            XCTAssertNil($0.effects)
        }
    }
}
