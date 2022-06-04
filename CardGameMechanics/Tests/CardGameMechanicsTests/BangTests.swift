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
import ExtensionsKit

class BangTests: XCTestCase {
    /*
    private var cancellables: [Cancellable] = []
    
    func test_DealDamage_IfPlayingBang() {
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2)
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"])
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1", target: "p2"),
                                  Damage(value: 1, target: "p2", type: Args.effectTypeShoot)])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p2").health, 1)
        XCTAssertEqual(sut.state.value.sequences, [:])
    }
    
    func test_ThrowError_IfPlayingBangWithoutTarget() {
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2)
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"])
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [ErrorInvalidTarget(player: nil)])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [c1])
        XCTAssertEqual(sut.state.value.sequences, [:])
    }
    
    func test_ThrowError_IfPlayingBangWithInvalidTarget() {
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2)
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"])
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1", target: "pX"))
        
        // Assert
        XCTAssertEqual(messages, [ErrorInvalidTarget(player: "pX")])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [c1])
        XCTAssertEqual(sut.state.value.sequences, [:])
    }
     */
}
