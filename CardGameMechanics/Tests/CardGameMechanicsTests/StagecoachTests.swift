//
//  StagecoachTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 06/06/2022.
//

import XCTest
import Combine
import CardGameMechanics
import CardGameCore

class StagecoachTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_Draw2Cards_IfPlayingStagecoach() {
        // Given
        let c1 = Cards.get("stagecoach").withId("c1")
        let c2 = Card().withId("c2")
        let c3 = Card().withId("c3")
        let p1 = Player(hand: [c1])
        let state = State(players: ["p1": p1],
                          turn: "p1",
                          phase: 2,
                          deck: [c2, c3])
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events[0], Play(card: "c1", actor: "p1"))
        XCTAssertEqual(events[1], Draw(player: "p1"))
        XCTAssertEqual(events[2], Draw(player: "p1"))
        
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p1").hand, [c2, c3])
    }
    
    func test_ResetDeck_IfDrawingLastDeckCard() throws {
        // Given
        let c1 = Cards.get("stagecoach").withId("c1")
        let c2 = Card().withId("c2")
        let p1 = Player(hand: [c1])
        let state = State(players: ["p1": p1],
                          turn: "p1",
                          phase: 2,
                          discard: [c2, c2])
        let sut = Game(state)
        var events: [Event] = []
        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
        
        // When
        sut.input(Play(card: "c1", actor: "p1"))
        
        // Assert
        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events[0], Play(card: "c1", actor: "p1"))
        XCTAssertEqual(events[1], Draw(player: "p1"))
        XCTAssertEqual(events[2], Draw(player: "p1"))
        
        XCTAssertEqual(sut.state.value.discard, [c1])
        XCTAssertEqual(sut.state.value.player("p1").hand, [c2, c2])
    }
    
}
