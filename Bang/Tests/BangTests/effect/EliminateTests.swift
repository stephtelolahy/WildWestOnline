//
//  EliminateTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

import XCTest
import Bang

final class EliminateTests: XCTestCase {
    
    func test_RemovePlayerFromPlayOrder_IfEliminate() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1", "p2", "p3"])
        let sut = Eliminate(player: PlayerId("p1"))
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.playOrder, ["p2", "p3"])
        }
    }
    
    // TODO: do not elmiminate is health not zero
}
