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
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_SetNextTurn_IfEndingTurn() {
        // Given
        let endTurn = Cards.get("endTurn")
        let p1 = Player(health: 1, inner: [endTurn])
        let p2 = Player()
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p2", "p3", "p1"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "endTurn", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events[0], Play(card: "endTurn", actor: "p1"))
        XCTAssertEqual(events[1], SetTurn(player: "p2"))
        XCTAssertEqual(events[2], SetPhase(value: 1))
        
        XCTAssertEqual(sut.state.value.turn, "p2")
        XCTAssertEqual(sut.state.value.played, [])
        XCTAssertEqual(sut.state.value.phase, 1)
    }
    
    func test_DiscardExcess1Card_IfEndingTurn() {
        // Given
        let endTurn = Cards.get("endTurn")
        let c1 = Card().withId("c1")
        let c2 = Card().withId("c2")
        let p1 = Player(health: 1, inner: [endTurn], hand: [c1, c2])
        let p2 = Player()
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p3", "p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "endTurn", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Play(card: "endTurn", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Choose(value: "c1", actor: "p1"))
        XCTAssertEqual(sut.state.value.decisions[1], Choose(value: "c2", actor: "p1"))
        
        // phase: p1 discard card
        events.removeAll()
        sut.input(sut.state.value.decisions[1])
        
        // Assert
        XCTAssertEqual(events.count, 4)
        XCTAssertEqual(events[0], Choose(value: "c2", actor: "p1"))
        XCTAssertEqual(events[1], Discard(card: "c2", player: "p1"))
        XCTAssertEqual(events[2], SetTurn(player: "p2"))
        XCTAssertEqual(events[3], SetPhase(value: 1))
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [c1])
        XCTAssertEqual(sut.state.value.turn, "p2")
        XCTAssertEqual(sut.state.value.played, [])
    }
    
    func test_DiscardExcess2Cards_IfEndingTurn() {
        // Given
        let endTurn = Cards.get("endTurn")
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
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "endTurn", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Play(card: "endTurn", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 3)
        XCTAssertEqual(sut.state.value.decisions[0], Choose(value: "c1", actor: "p1"))
        XCTAssertEqual(sut.state.value.decisions[1], Choose(value: "c2", actor: "p1"))
        XCTAssertEqual(sut.state.value.decisions[2], Choose(value: "c3", actor: "p1"))
        
        // phase: p1 discard first card
        events.removeAll()
        sut.input(sut.state.value.decisions[1])
        
        // Assert
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0], Choose(value: "c2", actor: "p1"))
        XCTAssertEqual(events[1], Discard(card: "c2", player: "p1"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Choose(value: "c1", actor: "p1"))
        XCTAssertEqual(sut.state.value.decisions[1], Choose(value: "c3", actor: "p1"))
        
        // phase: p1 discard second card
        events.removeAll()
        sut.input(sut.state.value.decisions[1])
        
        // Assert
        XCTAssertEqual(events.count, 4)
        XCTAssertEqual(events[0], Choose(value: "c3", actor: "p1"))
        XCTAssertEqual(events[1], Discard(card: "c3", player: "p1"))
        XCTAssertEqual(events[2], SetTurn(player: "p2"))
        XCTAssertEqual(events[3], SetPhase(value: 1))
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [c1])
        XCTAssertEqual(sut.state.value.turn, "p2")
        XCTAssertEqual(sut.state.value.played, [])
    }
}
