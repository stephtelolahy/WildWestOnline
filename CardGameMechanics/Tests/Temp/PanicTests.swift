//
//  PanicTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 06/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore
import ExtensionsKit

class PanicTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_StealOthersUniqueHandCard_IfPlayingPanic() {
        // Given
        let c1 = Cards.get("panic").withId("c1")
        let c2 = Card().withId("c2")
        let p1 = Player(hand: [c1])
        let p2 = Player(hand: [c2])
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        
        XCTAssertEqual(sut.state.value.decisions["p1"]?.options, [Choose(value: "p2", actor: "p1")])
        
        // Phase: select target
        // When
        messages.removeAll()
        sut.input(Choose(value: "p2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "p2", actor: "p1"),
                                  Steal(actor: "p1", card: "c2", target: "p2")])
        
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p2").hand, [])
        XCTAssertEqual(sut.state.value.player("p1").hand, [c2])
        XCTAssertEqual(sut.state.value.sequences, [])
    }
    
    func test_StealOthersInPlayCard_IfPlayingPanic() {
        // Given
        let c1 = Cards.get("panic").withId("c1")
        let c2 = Card().withId("c2")
        let c3 = Card().withId("c3")
        let p1 = Player(hand: [c1])
        let p2 = Player(hand: [c2], inPlay: [c3])
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        
        XCTAssertEqual(sut.state.value.decisions["p1"]?.options, [Choose(value: "p2", actor: "p1")])
        
        // Phase: select target
        // When
        messages.removeAll()
        sut.input(Choose(value: "p2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "p2", actor: "p1")])
        
        XCTAssertEqual(sut.state.value.decisions["p1"]?.options, [Choose(value: "c3", actor: "p1"),
                                                                  Choose(value: Args.cardRandomHand, actor: "p1")])
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        
        // Phase: Select card
        messages.removeAll()
        sut.input(Choose(value: "c3", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "c3", actor: "p1"),
                                  Steal(actor: "p1", card: "c3", target: "p2")])
        
        XCTAssertEqual(sut.state.value.player("p2").hand, [c2])
        XCTAssertEqual(sut.state.value.player("p2").inPlay, [])
        XCTAssertEqual(sut.state.value.player("p1").hand, [c3])
        XCTAssertEqual(sut.state.value.sequences, [])
    }
    
    func test_CannotPlayPanic_IfNoCardsToSteal() {
        // Given
        let c1 = Cards.get("panic").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player()
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [ErrorPlayerHasNoCard(player: "p2")])
    }
}
