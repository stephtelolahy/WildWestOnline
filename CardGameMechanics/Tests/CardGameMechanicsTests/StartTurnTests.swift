//
//  StartTurnTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//

import XCTest
import Combine
import CardGameCore
import CardGameMechanics

class StartTurnTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_Draw2CardsAndSetTurnStarted_IfStartingTurn() {
        // Given
        let startTurn = Cards.get("startTurn")
        let p1 = Player(inner: [startTurn])
        let deck = [Card(), Card()]
        let state = State(players: ["p1": p1],
                          turn: "p1",
                          phase: 1,
                          deck: deck)
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "startTurn", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 4)
        XCTAssertEqual(events[0], Play(card: "startTurn", actor: "p1"))
        XCTAssertEqual(events[1], Draw(player: "p1"))
        XCTAssertEqual(events[2], Draw(player: "p1"))
        XCTAssertEqual(events[3], SetPhase(value: 2))
        
        XCTAssertEqual(sut.state.value.phase, 2)
        XCTAssertEqual(sut.state.value.player("p1").hand.count, 2)
    }
}
