//
//  EquatableTests.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

import XCTest
import Bang

final class EquatableTests: XCTestCase {
    
    func test_EquatableEvent() {
        let move1 = Choose(actor: "p1", label: "c1")
        let move2 = Choose(actor: "p1", label: "c1")
        XCTAssertTrue(move1.isEqualTo(move2))
    }
    
    func test_EquatalRepeat() {
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
    
    func test_EqualChooseOne_IgnoringOptions() {
        XCTAssertEqual(ChooseOne([Choose(actor: "p1", label: "c1")]),
                       ChooseOne([Choose(actor: "p1", label: "c2")]))
        
        assertEqual(ChooseOne([Choose(actor: "p1", label: "c1")]) as Event,
                    ChooseOne([Choose(actor: "p1", label: "c2")]))
    }
    
    func testEqualChoose_ignoringChildren() {
        XCTAssertEqual(Choose(actor: "p1", label: "c1", children: [Store()]),
                       Choose(actor: "p1", label: "c1", children: [DrawDeck(player: PlayerId("p1"))]))
    }
}
