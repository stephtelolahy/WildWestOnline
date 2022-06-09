//
//  SaloonTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 06/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore
import ExtensionsKit

class SaloonTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_AllDamagedPlayersGainHealth_IfPlayingSaloon() {
        // Given
        let c1 = Cards.get("saloon").withId("c1")
        let p1 = Player(maxHealth: 4, health: 1, hand: [c1])
        let p2 = Player(maxHealth: 3, health: 2)
        let p3 = Player(maxHealth: 3, health: 3)
        let state = State(players: ["p1": p1, "p2": p2, "p3": p3],
                          playOrder: ["p3", "p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1"),
                                  Heal(value: 1, target: "p1"),
                                  Heal(value: 1, target: "p2"),
                                  ErrorPlayerAlreadyMaxHealth(player: "p3")])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p1").health, 2)
        XCTAssertEqual(sut.state.value.player("p2").health, 3)
        XCTAssertEqual(sut.state.value.player("p3").health, 3)
    }
    
    func test_CannotPlaySaloon_IfAllPlayersMaxHealth() {
        let c1 = Cards.get("saloon").withId("c1")
        let p1 = Player(maxHealth: 4, health: 4, hand: [c1])
        let p2 = Player(maxHealth: 3, health: 3)
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [ErrorPlayerAlreadyMaxHealth(player: "p1")])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [c1])
        XCTAssertEqual(sut.state.value.player("p1").health, 4)
        XCTAssertEqual(sut.state.value.player("p2").health, 3)
    }
    
}
