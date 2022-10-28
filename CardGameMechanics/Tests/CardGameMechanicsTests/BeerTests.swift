//
//  BeerTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import XCTest
import CardGameCore
import CardGameMechanics
import Combine

class BeerTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_GainHealth_IfPlayingBeer() {
        // Given
        let c1 = Cards.get("beer").withId("c1")
        let p1 = Player(maxHealth: 4, health: 1, hand: [c1])
        let state = State(players: ["p1": p1],
                          playOrder: ["p1", "p2", "p3"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0], Play(card: "c1", actor: "p1"))
        XCTAssertEqual(events[1], Heal(value: 1, player: "p1"))
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p1").health, 2)
    }
    
    func test_CannotPlayBeer_IfTwoPlayersLeft() {
        // Given
        let c1 = Cards.get("beer").withId("c1")
        let p1 = Player(maxHealth: 4, health: 2, hand: [c1])
        let state = State(players: ["p1": p1],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], ErrorIsPlayersAtLeast(count: 3))
    }
    
    func test_CannotPlayBeer_IfMaxHealth() {
        // Given
        let c1 = Cards.get("beer").withId("c1")
        let p1 = Player(maxHealth: 4, health: 4, hand: [c1])
        let state = State(players: ["p1": p1],
                          playOrder: ["p1", "p2", "p3"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], ErrorPlayerAlreadyMaxHealth(player: "p1"))
    }
}
