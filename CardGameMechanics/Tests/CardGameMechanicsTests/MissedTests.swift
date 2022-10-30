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
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Play(card: "c1", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        
        XCTAssertEqual(sut.state.value.decisions.count, 1)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "p2", actor: "p1"))
        
        // Phase: p1 choose target p2
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Select(value: "p2", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p2"))
        
        // Phase: p2 counter
        // when
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(events[1], Discard(card: "c2", player: "p2"))
        
        XCTAssertEqual(sut.state.value.discard, [c1, c2])
        XCTAssertEqual(sut.state.value.player("p2").hand, [])
        XCTAssertEqual(sut.state.value.player("p2").health, 2)
        XCTAssertEqual(sut.state.value.decisions.count, 0)
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
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Play(card: "c1", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        
        XCTAssertEqual(sut.state.value.decisions.count, 1)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "p2", actor: "p1"))
        
        // Phase: p1 choose target p2
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Select(value: "p2", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p2"))
        
        // Phase: p2 passes
        // when
        events.removeAll()
        sut.input(sut.state.value.decisions[1])
        
        // Assert
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0], Select(value: nil, actor: "p2"))
        XCTAssertEqual(events[1], Damage(value: 1, player: "p2"))
        
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p2").hand, [c2])
        XCTAssertEqual(sut.state.value.player("p2").health, 1)
        XCTAssertEqual(sut.state.value.decisions.count, 0)
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
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Play(card: "c1", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p2"))
        
        // Phase: p2 counter
        // When
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(events[1], Discard(card: "c2", player: "p2"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c3", actor: "p3"))
        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p3"))
        
        // Phase: p3 counter
        // When
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0], Select(value: "c3", actor: "p3"))
        XCTAssertEqual(events[1], Discard(card: "c3", player: "p3"))
        
        XCTAssertEqual(sut.state.value.player("p2").health, 2)
        XCTAssertEqual(sut.state.value.player("p3").health, 3)
        XCTAssertEqual(sut.state.value.decisions.count, 0)
    }
    
    func test_CannotPlayMissed_CardHasNoEffect() {
        // Given
        let c1 = Cards.get("missed").withId("c1")
        let p1 = Player(hand: [c1])
        let state = State(players: ["p1": p1])
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], ErrorCardHasNoEffect())
    }
}
