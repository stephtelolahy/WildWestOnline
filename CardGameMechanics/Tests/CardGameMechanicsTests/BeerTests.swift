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
import ExtensionsKit

class BeerTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_GainHealth_IfPlayingBeer_Damaged() {
        // Given
        let c1 = Cards.get("beer").withId("c1")
        let p1 = Player(maxHealth: 4, health: 1, hand: [c1])
        let state = State(players: ["p1": p1], playOrder: ["p1", "p2", "p3"])
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
        XCTAssertEqual(sut.state.value.sequences, [:])
    }
    
    func test_NoEffect_IfPlayingBeer_MaxHealth() {
        // Given
        let c1 = Cards.get("beer").withId("c1")
        let p1 = Player(maxHealth: 4, health: 4, hand: [c1])
        let state = State(players: ["p1": p1], playOrder: ["p1", "p2", "p3"])
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1"),
                                  ErrorPlayerAlreadyMaxHealth(player: "p1")])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p1").health, 4)
        XCTAssertEqual(sut.state.value.sequences, [:])
    }
    
    func test_CannotPlayBeer_IfTwoPlayersLeft() {
        // Given
        let c1 = Cards.get("beer").withId("c1")
        let p1 = Player(maxHealth: 4, health: 2, hand: [c1])
        let state = State(players: ["p1": p1], playOrder: ["p1", "p2"])
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [ErrorPlayersMustBeAtLeast(count: 3)])
        XCTAssertEqual(sut.state.value.sequences, [:])
    }
    
}
