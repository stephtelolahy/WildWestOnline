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

class WellsFargoTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
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
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 4)
        XCTAssertEqual(events[0], Play(card: "c1", actor: "p1"))
        XCTAssertEqual(events[1], Draw(player: "p1"))
        XCTAssertEqual(events[2], Draw(player: "p1"))
        XCTAssertEqual(events[3], Draw(player: "p1"))
        
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p1").hand, [c2, c3, c4])
    }
    
}
