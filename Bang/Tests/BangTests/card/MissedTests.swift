//
//  MissedTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class MissedTests: EngineTestCase {
    
    func test_CounterShoot_IfPlayingMissed() throws {
        // Given
        let c1 = inventory.getCard("bang", withId: "c1")
        let c2 = inventory.getCard("missed", withId: "c2")
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
            .wait([Choose(player: "p1", label: "p2")]),
            .input(0),
            .success(Choose(player: "p1", label: "p2")),
            .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandMatch("missed"))),
            .wait([Choose(player: "p2", label: "c2"),
                   Choose(player: "p2", label: Label.pass)]),
            .input(0),
            .success(Choose(player: "p2", label: "c2")),
            .success(Discard(player: PlayerId("p2"), card: CardId("c2")))
        ])
    }
    
    func test_DoNotCounterShoot_IfMissedNotPlayed() throws {
        // Given
        let c1 = inventory.getCard("bang", withId: "c1")
        let c2 = inventory.getCard("missed", withId: "c2")
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
            .wait([Choose(player: "p1", label: "p2")]),
            .input(0),
            .success(Choose(player: "p1", label: "p2")),
            .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandMatch("missed"))),
            .wait([Choose(player: "p2", label: "c2"),
                   Choose(player: "p2", label: Label.pass)]),
            .input(1),
            .success(Choose(player: "p2", label: "c2")),
            .success(Damage(player: PlayerId("p2"), value: 1))
        ])
    }
    
//    func test_CounterMultipleShoot_IfPlayingMultipleMissed() {
//        // Given
//        let c1 = Cards.get("gatling").withId("c1")
//        let p1 = Player(hand: [c1])
//        let p2 = Player(health: 2, hand: [Cards.get("missed").withId("c2")])
//        let p3 = Player(health: 3, hand: [Cards.get("missed").withId("c3")])
//        let state = State(players: ["p1": p1, "p2": p2, "p3": p3],
//                          playOrder: ["p1", "p2", "p3"],
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
//        XCTAssertEqual(sut.state.value.player("p1").hand, [])
//        XCTAssertEqual(sut.state.value.discard, [c1])
//
//        XCTAssertEqual(sut.state.value.decisions.count, 2)
//        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c2", actor: "p2"))
//        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p2"))
//
//        // Phase: p2 counter
//        // When
//        events.removeAll()
//        sut.input(sut.state.value.decisions[0])
//
//        // Assert
//        XCTAssertEqual(events.count, 2)
//        XCTAssertEqual(events[0], Select(value: "c2", actor: "p2"))
//        XCTAssertEqual(events[1], Discard(card: "c2", player: "p2"))
//
//        XCTAssertEqual(sut.state.value.decisions.count, 2)
//        XCTAssertEqual(sut.state.value.decisions[0], Select(value: "c3", actor: "p3"))
//        XCTAssertEqual(sut.state.value.decisions[1], Select(value: nil, actor: "p3"))
//
//        // Phase: p3 counter
//        // When
//        events.removeAll()
//        sut.input(sut.state.value.decisions[0])
//
//        XCTAssertEqual(events.count, 2)
//        XCTAssertEqual(events[0], Select(value: "c3", actor: "p3"))
//        XCTAssertEqual(events[1], Discard(card: "c3", player: "p3"))
//
//        XCTAssertEqual(sut.state.value.player("p2").health, 2)
//        XCTAssertEqual(sut.state.value.player("p3").health, 3)
//        XCTAssertEqual(sut.state.value.decisions.count, 0)
//    }
    
    func test_CannotPlayMissed_CardHasNoEffect() throws {
        // Given
        let c1 = inventory.getCard("missed", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))

        // Assert
        try assertSequence([.error(.cardHasNoEffect)])
    }

}
