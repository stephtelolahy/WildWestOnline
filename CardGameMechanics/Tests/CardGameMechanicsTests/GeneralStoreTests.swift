//
//  GeneralStoreTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore

class GeneralStoreTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_EachPlayerChooseCard_IfPlayingGeneralStore() {
        // Given
        let c1 = Cards.get("generalStore").withId("c1")
        let c2 = Card().withId("c2")
        let c3 = Card().withId("c3")
        let c4 = Card().withId("c4")
        let p1 = Player(hand: [c1])
        let p2 = Player()
        let p3 = Player()
        let state = State(players: ["p1": p1, "p2": p2, "p3": p3],
                          playOrder: ["p1", "p2", "p3"],
                          turn: "p1",
                          phase: 2,
                          deck: [c2, c3, c4])
        let sut = Game(state)
        var messages: [Event] = []
        sut.state.sink { messages.append($0.event) }.store(in: &cancellables)
        
        // Phase: Play
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Play(card: "c1", actor: "p1"),
                                  DeckToStore(),
                                  DeckToStore(),
                                  DeckToStore()])
        XCTAssertEqual(sut.state.value.store, [c2, c3, c4])
        XCTAssertEqual(sut.state.value.decisions, [Choose(value: "c2", actor: "p1"),
                                                   Choose(value: "c3", actor: "p1"),
                                                   Choose(value: "c4", actor: "p1")])
        
        // Phase: p1 Choose card
        // When
        messages.removeAll()
        sut.input(Choose(value: "c2", actor: "p1"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "c2", actor: "p1"),
                                  DrawStore(card: "c2", player: "p1")])
        XCTAssertEqual(sut.state.value.store, [c3, c4])
        XCTAssertEqual(sut.state.value.players["p1"]?.hand, [c2])
        XCTAssertEqual(sut.state.value.decisions, [Choose(value: "c3", actor: "p2"),
                                                   Choose(value: "c4", actor: "p2")])
        
        // Phase: p2 Choose card
        messages.removeAll()
        sut.input(Choose(value: "c4", actor: "p2"))
        
        // Assert
        XCTAssertEqual(messages, [Choose(value: "c4", actor: "p2"),
                                  DrawStore(card: "c4", player: "p2"),
                                  DrawStore(card: "c3", player: "p3")])
        XCTAssertEqual(sut.state.value.store, [])
        XCTAssertEqual(sut.state.value.players["p2"]?.hand, [c4])
        XCTAssertEqual(sut.state.value.players["p3"]?.hand, [c3])
    }
    
}
