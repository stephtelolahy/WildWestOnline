//
//  BangTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore

class BangTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_DealDamage_IfPlayingBang() {
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2)
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
        
        // Phase: choose target
        // When
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0], Select(value: "p2", actor: "p1"))
        XCTAssertEqual(events[1], Damage(value: 1, player: "p2"))
        
        XCTAssertEqual(sut.state.value.player("p2").health, 1)
        XCTAssertEqual(sut.state.value.decisions.count, 0)
    }
    
    func test_CannotPlayBang_IfNoPlayerReachable() {
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let p1 = Player(hand: [c1])
        let state = State(players: ["p1": p1],
                          playOrder: ["p1"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], ErrorNoPlayersAtRange(distance: 1))
    }
    
    func test_CannotPlayBang_IfReachedLimitPerTurn() throws {
        // TODO
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2)
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2,
                          played: ["bang"])
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], ErrorIsTimesPerTurn(max: 1))
    }
}
