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
import ExtensionsKit

class StartTurnTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_Draw2CardsAndSetTurnStarted_IfStartingTurn() {
        // Given
        let startTurn = Cards.get("startTurn").withId("startTurn")
        let p1 = Player(inner: [startTurn])
        let deck = [Card(), Card()]
        let state = State(players: ["p1": p1], turn: "p1", turnPhase: 1, deck: deck)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "startTurn", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "startTurn", actor: "p1"),
                                  Draw(target: "p1"),
                                  Draw(target: "p1"),
                                  SetPhase(value: 2)])
        
        XCTAssertEqual(sut.state.value.turnPhase, 2)
        XCTAssertEqual(sut.state.value.player("p1").hand.count, 2)
    }
}
