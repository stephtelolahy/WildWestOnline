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
    
    private var cancellables: [Cancellable] = []
    
    func test_GainHealth_IfPlayingBeer() {
        // Given
        let c1 = Cards.get("beer").withId("c1")
        let p1 = Player(maxHealth: 4, health: 1, hand: [c1])
        let state = State(players: ["p1": p1],
                          playOrder: ["p1", "p2", "p3"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1"),
                                  Heal(value: 1, target: "p1")])
        
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
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [ErrorIsPlayersAtLeast(count: 3)])
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
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [ErrorPlayerAlreadyMaxHealth(player: "p1")])
    }
}
