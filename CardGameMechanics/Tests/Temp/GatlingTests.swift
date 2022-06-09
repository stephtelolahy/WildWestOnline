//
//  GatlingTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore
import ExtensionsKit

class GatlingTests: XCTestCase {

    private var cancellables: [Cancellable] = []
    
    func test_DamageOthers_IfPlayingGatling() {
        // Given
        let c1 = Cards.get("gatling").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2)
        let p3 = Player(health: 3)
        let state = State(players: ["p1": p1, "p2": p2, "p3": p3],
                          playOrder: ["p3", "p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1"),
                                  Damage(value: 1, target: "p2", type: Args.effectTypeShoot),
                                  Damage(value: 1, target: "p3", type: Args.effectTypeShoot)])
        
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p2").health, 1)
        XCTAssertEqual(sut.state.value.player("p3").health, 2)
        XCTAssertEqual(sut.state.value.sequences, [])
    }

}
