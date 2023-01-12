//
//  PanicTests.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class PanicTests: EngineTestCase {

    func test_StealOthersUniqueHandCard_IfPlayingPanic() throws {
        // Given
        let c1 = inventory.getCard("panic", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .wait([Choose(actor: "p1", label: "p2")],
                  input: 0),
            .success(Choose(actor: "p1", label: "p2")),
            .wait([Choose(actor: "p1", label: ArgCard.randomHandLabel)],
                  input: 0),
            .success(Choose(actor: "p1", label: ArgCard.randomHandLabel)),
            .success(Steal(player: .id("p1"), target: .id("p2"), card: .id("c2")))
        ])
    }
    
//    func test_StealOthersInPlayCard_IfPlayingPanic() {
//        // Given
//        let c1 = Cards.get("panic").withId("c1")
//        let c2 = Card().withId("c2")
//        let c3 = Card().withId("c3")
//        let p1 = Player(hand: [c1])
//        let p2 = Player(hand: [c2], inPlay: [c3])
//        let state = State(players: ["p1": p1, "p2": p2],
//                          playOrder: ["p1", "p2"],
//                          turn: "p1",
//                          phase: 2)
//        let sut = Game(state)
//        var events: [Event] = []
//        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
//
//        // Phase: Play
//        // When
//        sut.input(Play(card: "c1", actor: "p1"))
//
//        // Assert
//        XCTAssertEqual(events.count, 1)
//        XCTAssertEqual(events[0], Play(card: "c1", actor: "p1"))
//
//        XCTAssertEqual(sut.state.value.decisions.count, 1)
//        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "p2", actor: "p1"))
//
//        // Phase: choose target
//        // When
//        events.removeAll()
//        sut.input(sut.state.value.decisions[0])
//
//        // Assert
//        XCTAssertEqual(events.count, 1)
//        XCTAssertEqual(events[0], Select(value: "p2", actor: "p1"))
//
//        XCTAssertEqual(sut.state.value.decisions.count, 2)
//        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c3", actor: "p1"))
//        XCTAssertEqual(sut.state.value.decisions[1], Select(value: .CARD_RANDOM_HAND, actor: "p1"))
//
//        XCTAssertEqual(sut.state.value.player("p1").hand, [])
//        XCTAssertEqual(sut.state.value.discard, [c1])
//
//        // Phase: Select card
//        events.removeAll()
//        sut.input(sut.state.value.decisions[0])
//
//        // Assert
//        XCTAssertEqual(events.count, 2)
//        XCTAssertEqual(events[0], Select(value: "c3", actor: "p1"))
//        XCTAssertEqual(events[1], Steal(player: "p1", card: "c3", target: "p2"))
//
//        XCTAssertEqual(sut.state.value.player("p2").hand, [c2])
//        XCTAssertEqual(sut.state.value.player("p2").inPlay, [])
//        XCTAssertEqual(sut.state.value.player("p1").hand, [c3])
//        XCTAssertEqual(sut.state.value.decisions.count, 0)
//    }
//
//    func test_CannotPlayPanic_IfNoCardsToSteal() {
//        // Given
//        let c1 = Cards.get("panic").withId("c1")
//        let p1 = Player(hand: [c1])
//        let p2 = Player()
//        let state = State(players: ["p1": p1, "p2": p2],
//                          playOrder: ["p1", "p2"],
//                          turn: "p1",
//                          phase: 2)
//        let sut = Game(state)
//        var events: [Event] = []
//        sut.state.sink { events.append($0.event) }.store(in: &cancellables)
//
//        // Phase: Play
//        // When
//        sut.input(Play(card: "c1", actor: "p1"))
//
//        // Assert
//        XCTAssertEqual(events.count, 1)
//        XCTAssertEqual(events[0], ErrorPlayerHasNoCard(player: "p2"))
//        XCTAssertEqual(sut.state.value.decisions.count, 0)
//    }

}
