//
//  WellsFargoTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 06/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore
import ExtensionsKit

class WellsFargoTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_Draw3Cards_IfPlayingWellsFargo() {
        // Given
        let c1 = Cards.get("wellsFargo").withId("c1")
        let c2 = Card().withId("c2")
        let c3 = Card().withId("c3")
        let c4 = Card().withId("c4")
        let p1 = Player(hand: [c1])
        let state = State(players: ["p1": p1],
                          turn: "p1",
                          phase: 2,
                          deck: [c2, c3, c4])
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1"),
                                  Draw(target: "p1"),
                                  Draw(target: "p1"),
                                  Draw(target: "p1")])
        
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p1").hand, [c2, c3, c4])
        XCTAssertEqual(sut.state.value.sequences, [])
    }
    
}
