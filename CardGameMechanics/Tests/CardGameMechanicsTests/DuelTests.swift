//
//  DuelTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//

import XCTest
import CardGameCore
import CardGameMechanics
import Combine

class DuelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_TargetPlayerLooseHealth_IfPlayingDuel_AndNoBangCards() {
        // Given
        let c1 = Cards.get("duel").withId("c1")
        let p1 = Player(health: 2, hand: [c1])
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
        
        XCTAssertEqual(sut.state.value.player("p1").health, 2)
        XCTAssertEqual(sut.state.value.player("p2").health, 1)
        XCTAssertEqual(sut.state.value.decisions.count, 0)
    }
    
    func test_TargetPlayersDoNotLooseHealth_IfPlayingDuel_AndDiscarding1BangCards() {
        // Given
        let c1 = Cards.get("duel").withId("c1")
        let c2 = Cards.get("bang").withId("c2")
        let p1 = Player(health: 2, hand: [c1])
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
        
        // Phase: choose target
        // When
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Select(value: "p2", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p2"))
        
        // Phase: p2 discard bang
        // When
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(events[1], Discard(card: "c2", player: "p2"))
        XCTAssertEqual(events[2], Damage(value: 1, player: "p1"))
        
        XCTAssertEqual(sut.state.value.player("p1").health, 1)
        XCTAssertEqual(sut.state.value.player("p2").health, 2)
        XCTAssertEqual(sut.state.value.decisions.count, 0)
    }
    
    func test_TargetPlayersLooseHealth_IfPlayingDuel_AndDiscarding2BangCards() {
        // Given
        let c1 = Cards.get("duel").withId("c1")
        let c2 = Cards.get("bang").withId("c2")
        let c3 = Cards.get("bang").withId("c3")
        let p1 = Player(health: 2, hand: [c1, c3])
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
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [c3])
        XCTAssertEqual(sut.state.value.discard, [c1])
        
        XCTAssertEqual(sut.state.value.decisions.count, 1)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "p2", actor: "p1"))
        
        // Phase: choose target
        // When
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], Select(value: "p2", actor: "p1"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p2"))
        
        // Phase: p2 discard bang
        // When
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0], Select(value: "c2", actor: "p2"))
        XCTAssertEqual(events[1], Discard(card: "c2", player: "p2"))
        
        XCTAssertEqual(sut.state.value.decisions.count, 2)
        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c3", actor: "p1"))
        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p1"))
        
        // Phase: p1 discard bang
        // When
        events.removeAll()
        sut.input(sut.state.value.decisions[0])
        
        // Assert
        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events[0], Select(value: "c3", actor: "p1"))
        XCTAssertEqual(events[1], Discard(card: "c3", player: "p1"))
        XCTAssertEqual(events[2], Damage(value: 1, player: "p2"))
        
        XCTAssertEqual(sut.state.value.player("p1").health, 2)
        XCTAssertEqual(sut.state.value.player("p2").health, 1)
        XCTAssertEqual(sut.state.value.decisions.count, 0)
    }
}
