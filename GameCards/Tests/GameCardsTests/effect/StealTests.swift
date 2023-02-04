//
//  StealTests.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameCore

final class StealTests: XCTestCase {

    func test_StealAnotherPlayerHandCard() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2])
        let sut = Steal(player: PlayerId("p1"), target: PlayerId("p2"), card: CardId("c2"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), ["c1", "c2"])
            XCTAssertEqual(ctx.player("p2").hand.map(\.id), [])
        }
    }
    
    func test_StealAnotherPlayerInPlayCard() throws {
        // Given
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(inPlay: [c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2])
        let sut = Steal(player: PlayerId("p1"), target: PlayerId("p2"), card: CardId("c2"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), ["c1", "c2"])
            XCTAssertEqual(ctx.player("p2").inPlay.map(\.id), [])
        }
    }

}
