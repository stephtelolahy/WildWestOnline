//
//  CatBalouTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 06/06/2022.
//

import XCTest
import CardGameCore
import CardGameMechanics
import Combine
import ExtensionsKit

class CatBalouTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_DiscardOthersUniqueHandCard_IfPlayingPanic() {
        // Given
        let c1 = Cards.get("catBalou").withId("c1")
        let c2 = Card().withId("c2")
        let p1 = Player(hand: [c1])
        let p2 = Player(hand: [c2])
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.decisions["p1"], [Choose(value: "p2", actor: "p1")])
        
        // Phase: select target
        // When
        messages.removeAll()
        sut.input(Choose(value: "p2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "p2", actor: "p1"),
                                  Discard(card: "c2", target: "p2")])
        XCTAssertEqual(sut.state.value.player("p2").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1, c2])
    }
    
    func test_DiscardOthersHandCard_IfPlayingCatBalou() {
        // Given
        let c1 = Cards.get("catBalou").withId("c1")
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
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.decisions["p1"], [Choose(value: "p2", actor: "p1")])
        
        // Phase: select target
        // When
        messages.removeAll()
        sut.input(Choose(value: "p2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "p2", actor: "p1")])
        XCTAssertEqual(sut.state.value.decisions["p1"], [Choose(value: "c3", actor: "p1"),
                                                         Choose(value: Args.cardRandomHand, actor: "p1")])
        
        // Phase: Select card
        messages.removeAll()
        sut.input(Choose(value: Args.cardRandomHand, actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: Args.cardRandomHand, actor: "p1"),
                                  Discard(card: "c2", target: "p2")])
        XCTAssertEqual(sut.state.value.player("p2").hand, [])
        XCTAssertEqual(sut.state.value.player("p2").inPlay, [c3])
        XCTAssertEqual(sut.state.value.discard, [c1, c2])
    }
    
    func test_DiscardOthersInPlayCard_IfPlayingCatBalou() {
        // Given
        let c1 = Cards.get("catBalou").withId("c1")
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
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1")])
        XCTAssertEqual(sut.state.value.player("p1").hand, [])
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.decisions["p1"], [Choose(value: "p2", actor: "p1")])
        
        // Phase: select target
        // When
        messages.removeAll()
        sut.input(Choose(value: "p2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "p2", actor: "p1")])
        XCTAssertEqual(sut.state.value.decisions["p1"], [Choose(value: "c3", actor: "p1"),
                                                         Choose(value: Args.cardRandomHand, actor: "p1")])
        
        // Phase: Select card
        messages.removeAll()
        sut.input(Choose(value: "c3", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "c3", actor: "p1"),
                                  Discard(card: "c3", target: "p2")])
        
        XCTAssertEqual(sut.state.value.player("p2").hand, [c2])
        XCTAssertEqual(sut.state.value.player("p2").inPlay, [])
        XCTAssertEqual(sut.state.value.discard, [c1, c3])
    }
    
    func test_CannotPlayCatBalou_IfNoCardsToDiscard() {
        // Given
        let c1 = Cards.get("catBalou").withId("c1")
        let p1 = Player(hand: [c1])
        let p2 = Player()
        let state = State(players: ["p1": p1, "p2": p2],
                          playOrder: ["p1", "p2"],
                          turn: "p1",
                          phase: 2)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.state.sink { messages.append($0.lastEvent) })
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [ErrorPlayerHasNoCard(player: "p2")])
    }
}
