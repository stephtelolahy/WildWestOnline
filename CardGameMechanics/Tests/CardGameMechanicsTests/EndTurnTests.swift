//
//  EndTurnTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//

import XCTest
import Combine
import CardGameCore
import CardGameMechanics

class EndTurnTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_SetNextTurn_IfEndingTurn() {
        // Given
        let endTurn = Cards.get("endTurn").withId("endTurn")
        let p1 = Player(health: 1, inner: [endTurn])
        let p2 = Player()
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p2", "p3", "p1"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "endTurn", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "endTurn", actor: "p1"),
                                  SetTurn(player: "p2"),
                                  SetPhase(value: 1)])
        
        XCTAssertEqual(sut.state.value.turn, "p2")
        XCTAssertEqual(sut.state.value.turnPlayed, [])
        XCTAssertEqual(sut.state.value.phase, 1)
    }
    
    func test_DiscardExcess1Card_IfEndingTurn() {
        // Given
        let endTurn = Cards.get("endTurn").withId("endTurn")
        let c1 = Card().withId("c1")
        let c2 = Card().withId("c2")
        let p1 = Player(health: 1, inner: [endTurn], hand: [c1, c2])
        let p2 = Player()
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p3", "p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "endTurn", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "endTurn", actor: "p1")])
        XCTAssertEqual(sut.state.value.decisions, [Choose(value: "c1", actor: "p1"),
                                                   Choose(value: "c2", actor: "p1")])
        
        // phase: p1 discard card
        messages.removeAll()
        sut.input(Choose(value: "c2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "c2", actor: "p1"),
                                  Discard(card: "c2", target: "p1"),
                                  SetTurn(player: "p2"),
                                  SetPhase(value: 1)])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [c1])
        XCTAssertEqual(sut.state.value.turn, "p2")
        XCTAssertEqual(sut.state.value.turnPlayed, [])
    }
    
    func test_DiscardExcess2Cards_IfEndingTurn() {
        // Given
        let endTurn = Cards.get("endTurn").withId("endTurn")
        let c1 = Card().withId("c1")
        let c2 = Card().withId("c2")
        let c3 = Card().withId("c3")
        let p1 = Player(health: 1, inner: [endTurn], hand: [c1, c2, c3])
        let p2 = Player()
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p3", "p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "endTurn", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "endTurn", actor: "p1")])
        XCTAssertEqual(sut.state.value.decisions, [Choose(value: "c1", actor: "p1"),
                                                   Choose(value: "c2", actor: "p1"),
                                                   Choose(value: "c3", actor: "p1")])
        
        // phase: p1 discard first card
        messages.removeAll()
        sut.input(Choose(value: "c2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "c2", actor: "p1"),
                                  Discard(card: "c2", target: "p1")])
        XCTAssertEqual(sut.state.value.decisions, [Choose(value: "c1", actor: "p1"),
                                                   Choose(value: "c3", actor: "p1")])
        
        // phase: p1 discard second card
        messages.removeAll()
        sut.input(Choose(value: "c3", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "c3", actor: "p1"),
                                  Discard(card: "c3", target: "p1"),
                                  SetTurn(player: "p2"),
                                  SetPhase(value: 1)])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [c1])
        XCTAssertEqual(sut.state.value.turn, "p2")
        XCTAssertEqual(sut.state.value.turnPlayed, [])
    }
}
