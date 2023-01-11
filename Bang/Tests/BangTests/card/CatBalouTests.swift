//
//  CatBalouTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class CatBalouTests: CardTests {
    
    func test_DiscardOthersUniqueHandCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard("catBalou", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupInitialState(ctx)
        
        // Phase: Play
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "c1"))
        
        XCTAssertEqual(state.player("p1").hand.map(\.id), [])
        XCTAssertEqual(state.discard.map(\.id), ["c1"])
        
        try XCTSkipUnless(state.decisions.count == 1, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: "p2"))
        
        // Phase: choose target
        // When
        events.removeAll()
        sut.input(state.decisions[0])
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: "p2"))
        
        try XCTSkipUnless(state.decisions.count == 1, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: ArgCard.randomHandLabel))
        
        // Phase: Select card
        events.removeAll()
        sut.input(state.decisions[0])
        
        // Assert
        try XCTSkipUnless(events.count == 2, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: ArgCard.randomHandLabel))
        assertIsSuccess(events[1], equalTo: Discard(player: .id("p2"), card: .id("c2")))
        XCTAssertEqual(state.player("p2").hand.map(\.id), [])
        XCTAssertEqual(state.discard.map(\.id), ["c1", "c2"])
        XCTAssertEqual(state.decisions.count, 0)
    }
    
    func test_DiscardOthersRandomHandCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard("catBalou", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2, c3])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupInitialState(ctx)
        
        // Phase: Play
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "c1"))
        
        XCTAssertEqual(state.player("p1").hand.map(\.id), [])
        XCTAssertEqual(state.discard.map(\.id), ["c1"])
        
        try XCTSkipUnless(state.decisions.count == 1, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: "p2"))
        
        // Phase: choose target
        // When
        events.removeAll()
        sut.input(state.decisions[0])
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: "p2"))
        
        try XCTSkipUnless(state.decisions.count == 1, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: ArgCard.randomHandLabel))
        
        // Phase: Select card
        events.removeAll()
        sut.input(state.decisions[0])
        
        // Assert
        try XCTSkipUnless(events.count == 2, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: ArgCard.randomHandLabel))
        XCTAssertEqual(state.player("p2").hand.count, 1)
        XCTAssertEqual(state.discard.count, 2)
        XCTAssertEqual(state.decisions.count, 0)
    }
    
    func test_DiscardOthersInPlayCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard("catBalou", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2], inPlay: [c3])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupInitialState(ctx)
        
        // Phase: Play
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "c1"))
        
        XCTAssertEqual(state.player("p1").hand.map(\.id), [])
        XCTAssertEqual(state.discard.map(\.id), ["c1"])
        
        try XCTSkipUnless(state.decisions.count == 1, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: "p2"))
        
        // Phase: choose target
        // When
        events.removeAll()
        sut.input(state.decisions[0])
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: "p2"))
        
        try XCTSkipUnless(state.decisions.count == 2, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", label: "c3"))
        assertEqual(state.decisions[1], Choose(actor: "p1", label: ArgCard.randomHandLabel))
        
        // Phase: Select card
        events.removeAll()
        sut.input(state.decisions[0])
        
        // Assert
        try XCTSkipUnless(events.count == 2, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", label: "c3"))
        assertIsSuccess(events[1], equalTo: Discard(player: .id("p2"), card: .id("c3")))
        XCTAssertEqual(state.player("p2").hand.map(\.id), ["c2"])
        XCTAssertEqual(state.player("p2").inPlay.map(\.id), [])
        XCTAssertEqual(state.discard.map(\.id), ["c1", "c3"])
        XCTAssertEqual(state.decisions.count, 0)
    }
    
    func test_CannotPlayCatBalou_IfNoCardsToDiscard() throws {
        // Given
        let c1 = inventory.getCard("catBalou", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupInitialState(ctx)
        
        // Phase: Play
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsFailure(events[0], equalTo: .playerHasNoCard("p2"))
    }
}
