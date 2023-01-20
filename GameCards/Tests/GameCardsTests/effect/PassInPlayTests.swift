//
//  PassInPlayTests.swift
//  
//
//  Created by Hugues Telolahy on 20/01/2023.
//

import XCTest
@testable import GameCards
import GameRules

final class PassInPlayTests: XCTestCase {
    
    func test_PassInPlay() throws {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1").inPlay(CardImpl(id: "c1")),
            PlayerImpl(id: "p2"))
        let sut = PassInPlay(player: PlayerId("p1"), card: CardId("c1"), target: PlayerId("p2"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").inPlay.map(\.id), [])
            XCTAssertEqual(ctx.player("p2").inPlay.map(\.id), ["c1"])
        }
    }
    
}
