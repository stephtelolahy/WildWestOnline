//
//  IsPlayersAtLeastTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
@testable import GameCards
import GameRules

final class IsPlayersAtLeastTests: XCTestCase {
    
    func test_ReturnTrue_IfPlayersMoreThanValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1", "p2", "p3"])
        let sut = IsPlayersAtLeast(2)
        
        // When
        let result = sut.match(ctx, playCtx: PlayContextImpl())
        
        // Assert
        assertIsSuccess(result)
    }
    
    func test_ReturnTrue_IfPlayersEqualValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1", "p2"])
        let sut = IsPlayersAtLeast(2)
        
        // When
        let result = sut.match(ctx, playCtx: PlayContextImpl())
        
        // Assert
        assertIsSuccess(result)
    }
    
    func test_ReturnTrue_IfPlayersLessThanValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1"])
        let sut = IsPlayersAtLeast(2)
        
        // When
        let result = sut.match(ctx, playCtx: PlayContextImpl())
        
        // Assert
        assertIsFailure(result, equalTo: .playersMustBeAtLeast(2))
    }    
}
