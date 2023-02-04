//
//  DrawStoreTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameCore

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
        let result = sut.resolve(ctx)
        
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
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let children = try XCTUnwrap($0.children)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0], ChooseOne([
                Choose(actor: "p1", label: "c1", children: [DrawStore(player: PlayerId("p1"), card: CardId("c1"))]),
                Choose(actor: "p1", label: "c2", children: [DrawStore(player: PlayerId("p1"), card: CardId("c2"))])
            ]))
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
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let children = try XCTUnwrap($0.children)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0], DrawStore(player: PlayerId("p1"), card: CardId("c1")))
        }
    }
    
}
