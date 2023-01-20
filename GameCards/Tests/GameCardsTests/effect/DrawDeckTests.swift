//
//  DrawDeckTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameRules

final class DrawDeckTests: XCTestCase {
    
    func test_DrawACardWhenHandNotEmpty() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           deck: [c2, c3])
        let sut = DrawDeck(player: PlayerId("p1"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), ["c1", "c2"])
            XCTAssertEqual(ctx.deck.map(\.id), ["c3"])
        }
    }
    
    func test_DrawACardWhenHandEmpty() throws {
        // Given
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1],
                           deck: [c2, c3])
        let sut = DrawDeck(player: PlayerId("p1"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), ["c2"])
            XCTAssertEqual(ctx.deck.map(\.id), ["c3"])
        }
    }
    
    func test_ResetDeck_IfEmpty() throws {
        // Given
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1],
                           discard: [c2, c3])
        let sut = DrawDeck(player: PlayerId("p1"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), ["c2"])
            XCTAssertEqual(ctx.deck.map(\.id), [])
            XCTAssertEqual(ctx.discard.map(\.id), ["c3"])
        }
    }
}
