//
//  IsPlayersAtLeastTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
import Bang

final class IsPlayersAtLeastTests: XCTestCase {
    
    private let sut: PlayReqVerifier = PlayReqVerifierImpl()
    
    func test_ReturnTrue_IfPlayersMoreThanValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1", "p2", "p3"])
        let playReq: PlayReq = .isPlayersAtLeast(2)
        
        // When
        let result = sut.verify(playReq, ctx: ctx)
        
        // assert
        assertIsSuccess(result)
    }
    
    func test_ReturnTrue_IfPlayersEqualValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1", "p2"])
        let playReq: PlayReq = .isPlayersAtLeast(2)
        
        // When
        let result = sut.verify(playReq, ctx: ctx)
        
        // assert
        assertIsSuccess(result)
    }
    
    func test_ReturnTrue_IfPlayersLessThanValue() throws {
        // Given
        let ctx: Game = GameImpl(playOrder: ["p1"])
        let playReq: PlayReq = .isPlayersAtLeast(2)
        
        // When
        let result = sut.verify(playReq, ctx: ctx)
        
        // assert
        assertIsFailure(result, equalTo: .playersMustBeAtLeast(2))
    }    
}
