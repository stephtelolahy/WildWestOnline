//
//  GameTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 02/06/2022.
//

import XCTest
import Combine
@testable import CardGameCore

class GameTests: XCTestCase {
    
    private var cancellables: [Cancellable] = []
    
    func test_ProcessLeafSequenceFirst() {
        // Given
        let e1 = DummyEffect(id: "e1")
        let ctx1 = Sequence(actor: "p1", card: Card(), queue: [e1])
        let e2 = DummyEffect(id: "e2")
        let ctx2 = Sequence(actor: "p2", card: Card(), parentRef: "c1", queue: [e2])
        let e3 = DummyEffect(id: "e3")
        let ctx3 = Sequence(actor: "p3", card: Card(), parentRef: "c2", queue: [e3])
        let e4 = DummyEffect(id: "e4")
        let ctx4 = Sequence(actor: "p4", card: Card(), parentRef: "c3", queue: [e4])
        
        let state = State(sequences: ["c1": ctx1, "c2": ctx2, "c3": ctx3, "c4": ctx4])
        
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [e4,
                                  e3,
                                  e2,
                                  e1])
        XCTAssertEqual(sut.state.value.sequences, [:])
    }
    
    #warning("move this test as card feature")
    /*
    func test_AskEndTurn_IfYourTurn() {
        // Given
        let endTurn = Cards.get("endTurn").withId("endTurn")
        let p1 = Player(health: 1, common: [endTurn])
        let state = State(players: ["p1": p1], playOrder: ["p2", "p1"], turn: "p1")
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [])
        XCTAssertEqual(sut.state.value.decisions["p1"], Decision(options: [Play(card: "endTurn", actor: "p1")]))
    }
    
    func test_AskPlay_IfYourTurn() {
        // Given
        let c1 = Cards.get("gatling").withId("c1")
        let p1 = Player(health: 1, hand: [c1])
        let state = State(players: ["p1": p1], playOrder: ["p2", "p1"], turn: "p1")
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [])
        XCTAssertEqual(sut.state.value.decisions["p1"], Decision(options: [Play(card: "c1", actor: "p1")]))
    }
    
    func test_AskPlayWithTarget_IfYourTurn() {
        // Given
        let c1 = Cards.get("bang").withId("c1")
        let p1 = Player(health: 1, hand: [c1])
        let state = State(players: ["p1": p1], playOrder: ["p2", "p1"], turn: "p1")
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [])
        XCTAssertEqual(sut.state.value.decisions["p1"], Decision(options: [Play(card: "c1", actor: "p1", target: "p2")]))
    }
    
    func test_DoNotAskPlay_IfPlayReqNotVerified() {
        // Given
        let c1 = Cards.get("beer").withId("c1")
        let p1 = Player(health: 1, hand: [c1])
        let state = State(players: ["p1": p1], playOrder: ["p2", "p1"], turn: "p1")
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [])
        XCTAssertNil(sut.state.value.decisions["p1"])
    }
    
    func test_DoNotAskCounter_IfYourTurn() {
        // Given
        let c1 = Cards.get("missed").withId("c1")
        let p1 = Player(hand: [c1])
        let state = State(players: ["p1": p1], turn: "p1")
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [])
        XCTAssertNil(sut.state.value.decisions["p1"])
    }
    
    func test_DoNotAskPlay_IfTurnNotStarted() {
        // Given
        let c1 = Cards.get("stagecoach").withId("c1")
        let p1 = Player(health: 1, hand: [c1])
        let state = State(players: ["p1": p1], turn: "p1", turnNotStarted: true)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [])
        XCTAssertNil(sut.state.value.decisions["p1"])
    }
    
    func test_StopUpdates_IfGameIsOver() {
        // Given
        let endTurn = Cards.get("endTurn").withId("endTurn")
        let p1 = Player(health: 1, common: [endTurn])
        let state = State(players: ["p1": p1], turn: "p1", isGameOver: true)
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [])
        XCTAssertTrue(sut.state.value.decisions.isEmpty)
    }
     */
    func test_CheckGameOver_IfIdle() {
        // Given
        let p1 = Player(health: 1)
        let p2 = Player(health: 0)
        let state = State(players: ["p1": p1, "p2": p2])
        let sut = Game(state)
        var messages: [Event] = []
        cancellables.append(sut.message.sink { messages.append($0) })
        
        // When
        sut.loopUpdate()
        
        // Assert
        XCTAssertEqual(messages, [])
        XCTAssertTrue(sut.state.value.isGameOver)
    }
}
