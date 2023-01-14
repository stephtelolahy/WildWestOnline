//
//  RuleDistanceTests.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

import XCTest
import Bang

final class RuleDistanceTests: XCTestCase {
    
    private let sut: RuleDistance = Rules.main

    func test_PlayerAtDistanceOf1When3Players() {
        // Given
        let ctx = GameImpl(playOrder: ["p1", "p2", "p3"])
        
        // When
        // Assert
        XCTAssertEqual(sut.playersAt(1, from: "p1", in: ctx), ["p2", "p3"])
        XCTAssertEqual(sut.playersAt(1, from: "p2", in: ctx), ["p1", "p3"])
        XCTAssertEqual(sut.playersAt(1, from: "p3", in: ctx), ["p1", "p2"])
    }
}
