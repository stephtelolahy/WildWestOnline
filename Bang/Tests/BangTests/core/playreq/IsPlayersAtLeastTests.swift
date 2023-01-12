//
//  IsPlayersAtLeastTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
import Bang

final class IsPlayersAtLeastTests: XCTestCase {
    
    func test_ReturnTrue_IfPlayersMoreThanValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1", "p2", "p3"])
        let sut = IsPlayersAtLeast(count: 2)
        
        // When
        let result = sut.verify(ctx)
        
        // Assert
        assertIsSuccess(result)
    }
    
    func test_ReturnTrue_IfPlayersEqualValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1", "p2"])
        let sut = IsPlayersAtLeast(count: 2)
        
        // When
        let result = sut.verify(ctx)
        
        // Assert
        assertIsSuccess(result)
    }
    
    func test_ReturnTrue_IfPlayersLessThanValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1"])
        let sut = IsPlayersAtLeast(count: 2)
        
        // When
        let result = sut.verify(ctx)
        
        // Assert
        assertIsFailure(result, equalTo: .playersMustBeAtLeast(2))
    }    
}
