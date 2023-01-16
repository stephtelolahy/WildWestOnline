//
//  EquatableTests.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

import XCTest
import Bang

final class EquatableTests: XCTestCase {

    func test_EquatableCast() {
        XCTAssertEqual(Repeat(times: NumExact(2), effect: Store()),
                       Repeat(times: NumExact(2), effect: Store()))
        
        XCTAssertEqual(Repeat(times: NumPlayers(), effect: Store()),
                       Repeat(times: NumPlayers(), effect: Store()))
        
        XCTAssertNotEqual(Repeat(times: NumExact(1), effect: Store()),
                          Repeat(times: NumExact(2), effect: Store()))
        
        XCTAssertNotEqual(Repeat(times: NumPlayers(), effect: Store()),
                          Repeat(times: NumExact(2), effect: Store()))
        
        XCTAssertNotEqual(Repeat(times: NumPlayers(), effect: Store()),
                          Repeat(times: NumPlayers(), effect: DrawDeck(player: PlayerId("p1"))))
    }
    
    func test_EquatableIgnore() {
        XCTAssertEqual(Choose(player: "p1", label: "c1", children: [Store().asNode()]),
                       Choose(player: "p1", label: "c1", children: [Dummy().asNode()]))
    }
}
