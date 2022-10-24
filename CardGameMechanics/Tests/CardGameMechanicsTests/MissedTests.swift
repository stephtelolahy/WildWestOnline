//
//  MissedTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore

class MissedTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_CounterShoot_IfPlayingMissed() {
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let c2 = Cards.get("missed").withId("c2")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2, hand: [c2])
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        sut.state.sink { messages.append($0.event) }.store(in: &cancellables)
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.decisions, [Choose(value: "p2", actor: "p1")])
        
        // Phase: p1 choose target p2
        messages.removeAll()
        sut.input(Choose(value: "p2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "p2", actor: "p1")])
        XCTAssertEqual(sut.state.value.decisions, [Play(card: "c2", actor: "p2"),
                                                   Choose(value: .CHOOSE_PASS, actor: "p2")])
        
        // Phase: p2 counter
        // when
        messages.removeAll()
        sut.input(Play(card: "c2", actor: "p2"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c2", actor: "p2"),
                                  Silent(type: .TYPE_SHOOT, player: "p2")])
        XCTAssertEqual(sut.state.value.discard, [c1, c2])
        XCTAssertEqual(sut.state.value.player("p2").hand, [])
        XCTAssertEqual(sut.state.value.player("p2").health, 2)
    }
    
    func test_DoNotCounterShoot_IfMissedNotPlayed() {
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let c2 = Cards.get("missed").withId("c2")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2, hand: [c2])
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        sut.state.sink { messages.append($0.event) }.store(in: &cancellables)
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.decisions, [Choose(value: "p2", actor: "p1")])
        
        // Phase: p1 choose target p2
        messages.removeAll()
        sut.input(Choose(value: "p2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "p2", actor: "p1")])
        XCTAssertEqual(sut.state.value.decisions, [Play(card: "c2", actor: "p2"),
                                                   Choose(value: .CHOOSE_PASS, actor: "p2")])
        
        // Phase: p2 passes
        // when
        messages.removeAll()
        sut.input(Choose(value: .CHOOSE_PASS, actor: "p2"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: .CHOOSE_PASS, actor: "p2"),
                                  Damage(value: 1, player: "p2", type: .TYPE_SHOOT)])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p2").hand, [c2])
        XCTAssertEqual(sut.state.value.player("p2").health, 1)
    }
    
    func test_CounterMultipleShoot_IfPlayingMultipleMissed() {
        // Given
        let c1 = Cards.get("gatling").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2, hand: [Cards.get("missed").withId("c2")])
        let p3 = Player(health: 3, hand: [Cards.get("missed").withId("c3")])
        let state = State(players: ["p1": p1, "p2": p2, "p3": p3],
                          playOrder: ["p1", "p2", "p3"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        sut.state.sink { messages.append($0.event) }.store(in: &cancellables)
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.decisions, [Play(card: "c2", actor: "p2"),
                                                   Choose(value: .CHOOSE_PASS, actor: "p2")])
        
        // Phase: p2 counter
        // When
        messages.removeAll()
        sut.input(Play(card: "c2", actor: "p2"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c2", actor: "p2"),
                                  Silent(type: .TYPE_SHOOT, player: "p2")])
        
        XCTAssertEqual(sut.state.value.decisions, [Play(card: "c3", actor: "p3"),
                                                   Choose(value: .CHOOSE_PASS, actor: "p3")])
        
        // Phase: p3 counter
        // When
        messages.removeAll()
        sut.input(Play(card: "c3", actor: "p3"))
        
        XCTAssertEqual(messages, [Play(card: "c3", actor: "p3"),
                                  Silent(type: .TYPE_SHOOT, player: "p3")])
        
        XCTAssertEqual(sut.state.value.player("p2").health, 2)
        XCTAssertEqual(sut.state.value.player("p3").health, 3)
    }
    
    func test_CannotPlayMissed_IfNoEffectToCounter() {
        // Given
        let c1 = Cards.get("missed").withId("c1")
        let p1 = Player(hand: [c1])
        let state = State(players: ["p1": p1])
        let sut = Game(state)
        var messages: [Event] = []
        sut.state.sink { messages.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [InternalError.contextCancelEffectNotFound])
    }
}
