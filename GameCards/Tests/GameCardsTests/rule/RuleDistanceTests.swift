//
//  RuleDistanceTests.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameRules

final class RuleDistanceTests: XCTestCase {
    
    private let sut: RuleDistance = RuleDistanceImpl()
    
    func test_ReturnLowestDistance() {
        // Given
        let p1 = PlayerImpl(id: "p1")
        let p2 = PlayerImpl(id: "p2")
        let p3 = PlayerImpl(id: "p3")
        let p4 = PlayerImpl(id: "p4")
        let p5 = PlayerImpl(id: "p5")
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3, "p4": p4, "p5": p5],
                           playOrder: ["p1", "p2", "p3", "p4", "p5"])
        
        // When
        // Assert
        XCTAssertEqual(sut.playersAt(1, from: "p1", in: ctx), ["p2", "p5"])
        XCTAssertEqual(sut.playersAt(2, from: "p1", in: ctx), ["p2", "p3", "p4", "p5"])
        
        XCTAssertEqual(sut.playersAt(1, from: "p2", in: ctx), ["p1", "p3"])
        XCTAssertEqual(sut.playersAt(2, from: "p2", in: ctx), ["p1", "p3", "p4", "p5"])
        
        XCTAssertEqual(sut.playersAt(1, from: "p3", in: ctx), ["p2", "p4"])
        XCTAssertEqual(sut.playersAt(2, from: "p3", in: ctx), ["p1", "p2", "p4", "p5"])
        
        XCTAssertEqual(sut.playersAt(1, from: "p4", in: ctx), ["p3", "p5"])
        XCTAssertEqual(sut.playersAt(2, from: "p4", in: ctx), ["p1", "p2", "p3", "p5"])
        
        XCTAssertEqual(sut.playersAt(1, from: "p5", in: ctx), ["p1", "p4"])
        XCTAssertEqual(sut.playersAt(2, from: "p5", in: ctx), ["p1", "p2", "p3", "p4"])
    }
    
    func test_DecrementDistanceToOthers_IfHavingScope() {
        // Given
        let p1 = PlayerImpl(id: "p1", scope: 1)
        let p2 = PlayerImpl(id: "p2")
        let p3 = PlayerImpl(id: "p3")
        let p4 = PlayerImpl(id: "p4")
        let p5 = PlayerImpl(id: "p5")
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3, "p4": p4, "p5": p5],
                           playOrder: ["p1", "p2", "p3", "p4", "p5"])
        
        // When
        // Assert
        XCTAssertEqual(sut.playersAt(1, from: "p1", in: ctx), ["p2", "p3", "p4", "p5"])
    }
    
    func test_IncrementDistanceFromOthers_IfHavingMustang() {
        // Given
        let p1 = PlayerImpl(id: "p1", mustang: 1)
        let p2 = PlayerImpl(id: "p2")
        let p3 = PlayerImpl(id: "p3")
        let p4 = PlayerImpl(id: "p4")
        let p5 = PlayerImpl(id: "p5")
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3, "p4": p4, "p5": p5],
                           playOrder: ["p1", "p2", "p3", "p4", "p5"])
        // When
        // Assert
        XCTAssertEqual(sut.playersAt(1, from: "p2", in: ctx), ["p3"])
        XCTAssertEqual(sut.playersAt(2, from: "p2", in: ctx), ["p1", "p3", "p4", "p5"])
        
        XCTAssertEqual(sut.playersAt(1, from: "p3", in: ctx), ["p2", "p4"])
        XCTAssertEqual(sut.playersAt(2, from: "p3", in: ctx), ["p2", "p4", "p5"])
        XCTAssertEqual(sut.playersAt(3, from: "p3", in: ctx), ["p1", "p2", "p4", "p5"])
        
        XCTAssertEqual(sut.playersAt(1, from: "p4", in: ctx), ["p3", "p5"])
        XCTAssertEqual(sut.playersAt(2, from: "p4", in: ctx), ["p2", "p3", "p5"])
        XCTAssertEqual(sut.playersAt(3, from: "p4", in: ctx), ["p1", "p2", "p3", "p5"])
        
        XCTAssertEqual(sut.playersAt(1, from: "p5", in: ctx), ["p4"])
        XCTAssertEqual(sut.playersAt(2, from: "p5", in: ctx), ["p1", "p2", "p3", "p4"])
    }
    
}
