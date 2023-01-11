//
//  EndTurnTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class EndTurnTests: CardTests {

    func test_SetNextTurn_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: nil)
        let p1 = PlayerImpl(health: 1, abilities: [endTurn])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p2", "p3", "p1"],
                           turn: "p1")
        setupInitialState(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "endTurn"))
        
        // Assert
        try XCTSkipUnless(events.count == 2, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "endTurn"))
        assertIsSuccess(events[1], equalTo: SetTurn(player: .id("p2")))
        
        XCTAssertEqual(state.turn, "p2")
        XCTAssertEqual(state.played, [])
    }
    
    func test_DiscardExcess1Card_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: nil)
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(health: 1, abilities: [endTurn], hand: [c1, c2])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupInitialState(ctx)

        // When
        sut.input(Play(actor: "p1", card: "endTurn"))

        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "endTurn"))

        try XCTSkipUnless(state.decisions.count == 2, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: "c1"))
        assertEqual(state.decisions[1], Choose(actor: "p1", label: "c2"))

        // phase: p1 discard card
        events.removeAll()
        sut.input(state.decisions[1])

        // Assert
        try XCTSkipUnless(events.count == 3, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: "c2"))
        assertIsSuccess(events[1], equalTo: Discard(player: .id("p1"), card: .id("c2")))
        assertIsSuccess(events[2], equalTo: SetTurn(player: .id("p2")))

        XCTAssertEqual(state.player("p1").hand.map(\.id), ["c1"])
        XCTAssertEqual(state.turn, "p2")
        XCTAssertEqual(state.played, [])
        XCTAssertEqual(state.decisions.count, 0)
    }

    func test_DiscardExcess2Cards_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: nil)
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(health: 1, abilities: [endTurn], hand: [c1, c2, c3])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p2", "p1"],
                           turn: "p1")
        setupInitialState(ctx)

        // When
        sut.input(Play(actor: "p1", card: "endTurn"))

        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "endTurn"))

        try XCTSkipUnless(state.decisions.count == 3, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: "c1"))
        assertEqual(state.decisions[1], Choose(actor: "p1", label: "c2"))
        assertEqual(state.decisions[2], Choose(actor: "p1", label: "c3"))

        // phase: p1 discard first card
        events.removeAll()
        sut.input(state.decisions[1])

        // Assert
        try XCTSkipUnless(events.count == 2, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: "c2"))
        assertIsSuccess(events[1], equalTo: Discard(player: .id("p1"), card: .id("c2")))

        try XCTSkipUnless(state.decisions.count == 2, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: "c1"))
        assertEqual(state.decisions[1], Choose(actor: "p1", label: "c3"))

        // phase: p1 discard second card
        events.removeAll()
        sut.input(state.decisions[1])

        // Assert
        try XCTSkipUnless(events.count == 3, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: "c3"))
        assertIsSuccess(events[1], equalTo: Discard(player: .id("p1"), card: .id("c3")))
        assertIsSuccess(events[2], equalTo: SetTurn(player: .id("p2")))

        XCTAssertEqual(state.player("p1").hand.map(\.id), ["c1"])
        XCTAssertEqual(state.turn, "p2")
        XCTAssertEqual(state.played, [])
        XCTAssertEqual(state.decisions.count, 0)
    }
}
