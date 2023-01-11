//
//  GeneralStoreTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name
// swiftlint:disable function_body_length

import XCTest
import Bang

final class GeneralStoreTests: CardTests {
    
    func test_EachPlayerChooseCard_IfPlayingGeneralStore() throws {
        // Given
        let c1 = inventory.getCard("generalStore", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let c4 = CardImpl(id: "c4")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let p3 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1",
                           deck: [c2, c3, c4])
        setupInitialState(ctx)
        
        // Phase: Play
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 4, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "c1"))
        assertIsSuccess(events[1], equalTo: Store())
        assertIsSuccess(events[2], equalTo: Store())
        assertIsSuccess(events[3], equalTo: Store())
        
        XCTAssertEqual(state.store.map(\.id), ["c2", "c3", "c4"])
        
        try XCTSkipUnless(state.decisions.count == 3, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p1", value: "c2"))
        assertEqual(state.decisions[1], Choose(actor: "p1", value: "c3"))
        assertEqual(state.decisions[2], Choose(actor: "p1", value: "c4"))
        
        // Phase: p1 Choose card
        // When
        events.removeAll()
        sut.input(state.decisions[0])
        
        // Assert
        try XCTSkipUnless(events.count == 2, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p1", value: "c2"))
        assertIsSuccess(events[1], equalTo: DrawStore(player: .id("p1"), card: .id("c2")))
        
        XCTAssertEqual(state.store.map(\.id), ["c3", "c4"])
        XCTAssertEqual(state.player("p1").hand.map(\.id), ["c2"])
        
        try XCTSkipUnless(state.decisions.count == 2, "Unexpected decisions count \(state.decisions.count)")
        assertEqual(state.decisions[0], Choose(actor: "p2", value: "c3"))
        assertEqual(state.decisions[1], Choose(actor: "p2", value: "c4"))
        
        // Phase: p2 Choose card
        events.removeAll()
        sut.input(state.decisions[1])
        
        // Assert
        try XCTSkipUnless(events.count == 3, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Choose(actor: "p2", value: "c4"))
        assertIsSuccess(events[1], equalTo: DrawStore(player: .id("p2"), card: .id("c4")))
        assertIsSuccess(events[2], equalTo: DrawStore(player: .id("p3"), card: .id("c3")))
        
        XCTAssertEqual(state.store.map(\.id), [])
        XCTAssertEqual(state.player("p2").hand.map(\.id), ["c4"])
        XCTAssertEqual(state.player("p3").hand.map(\.id), ["c3"])
        XCTAssertEqual(state.decisions.count, 0)
    }
    
}
