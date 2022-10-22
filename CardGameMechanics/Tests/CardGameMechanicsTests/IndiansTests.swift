//
//  IndiansTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore

class IndiansTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_OtherPlayersLooseHealth_IfPlayingIndians_AndNoBangCards() {
        // Given
        let c1 = Cards.get("indians").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2)
        let p3 = Player(health: 2)
        let state = State(players: ["p1": p1, "p2": p2, "p3": p3],
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
                                  Damage(value: 1, target: "p2"),
                                  Damage(value: 1, target: "p3")])
        
        XCTAssertEqual(sut.state.value.player("p2").health, 1)
        XCTAssertEqual(sut.state.value.player("p3").health, 1)
    }
    
    func test_OtherPlayersDoNotLooseHealth_IfPlayingIndians_AndDiscardingBangCards() {
        // Given
        let c1 = Cards.get("indians").withId("c1")
        let c2 = Cards.get("bang").withId("c2")
        let c3 = Cards.get("bang").withId("c3")
        let p1 = Player(hand: [c1])
        let p2 = Player(health: 2, hand: [c2])
        let p3 = Player(health: 2, hand: [c3])
        let state = State(players: ["p1": p1, "p2": p2, "p3": p3],
                          playOrder: ["p2", "p3", "p1"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        XCTAssertEqual(sut.state.value.decisions["p2"], [Choose(value: "c2", actor: "p2"),
                                                         Choose(value: Args.choosePass, actor: "p2")])
        
        // Phase: p2 discard bang
        // When
        messages.removeAll()
        sut.input(Choose(value: "c2", actor: "p2"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "c2", actor: "p2"),
                                  Discard(card: "c2", target: "p2")])
        
        XCTAssertEqual(sut.state.value.player("p2").health, 2)
        XCTAssertEqual(sut.state.value.decisions["p3"], [Choose(value: "c3", actor: "p3"),
                                                         Choose(value: Args.choosePass, actor: "p3")])
        
        // Phase: p3 passed
        // When
        messages.removeAll()
        sut.input(Choose(value: Args.choosePass, actor: "p3"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: Args.choosePass, actor: "p3"),
                                  Damage(value: 1, target: "p3")])
        
        XCTAssertEqual(sut.state.value.player("p3").health, 1)
    }
}
