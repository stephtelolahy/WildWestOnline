//
//  DrawStoreTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class DrawStoreTests: XCTestCase {
    
    func test_DrawSpecificStoreCard() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1],
                           store: [c1, c2])
        let sut = DrawStore(player: PlayerId("p1"), card: CardId("c1"))
        
        // When
        let result = sut.resolve(ctx, playCtx: PlayContextImpl())
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), ["c1"])
            XCTAssertEqual(ctx.store.map(\.id), ["c2"])
        }
    }
    
    func test_AskToChooseStoreCard() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1],
                           store: [c1, c2])
        let sut = DrawStore(player: PlayerId("p1"), card: CardSelectStore())
        
        // When
        let result = sut.resolve(ctx, playCtx: PlayContextImpl())
        
        // Assert
        assertIsSuccess(result) {
            let options: [EffectNode] = try XCTUnwrap($0.options)
            XCTAssertEqual(options.count, 2)
            assertEqual(options[0].effect, Choose(player: "p1", label: "c1", children: [DrawStore(player: PlayerId("p1"), card: CardId("c1")).asNode()]))
            assertEqual(options[1].effect, Choose(player: "p1", label: "c2", children: [DrawStore(player: PlayerId("p1"), card: CardId("c2")).asNode()]))
        }
    }
    
    func test_DoNotAskToChooseStoreCard() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let p1 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1],
                           store: [c1])
        let sut = DrawStore(player: PlayerId("p1"), card: CardSelectStore())
        
        // When
        let result = sut.resolve(ctx, playCtx: PlayContextImpl())
        
        // Assert
        assertIsSuccess(result) {
            let children: [EffectNode] = try XCTUnwrap($0.effects)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0].effect, DrawStore(player: PlayerId("p1"), card: CardId("c1")))
        }
    }
    
}
