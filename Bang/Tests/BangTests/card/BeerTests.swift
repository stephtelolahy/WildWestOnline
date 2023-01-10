//
//  BeerTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang
import Combine

final class BeerTests: CardTests {
    
    func test_GainHealth_IfPlayingBeer() throws {
        // Given
        let c1 = inventory.getCard("beer", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 1, hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1")
        setupInitialState(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 2, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "c1"))
        assertIsSuccess(events[1], equalTo: Heal(player: .id("p1"), value: 1))
        
        XCTAssertEqual(state.players["p1"]!.hand.map(\.id), [])
        XCTAssertEqual(state.players["p1"]!.health, 2)
        XCTAssertEqual(state.discard.map(\.id), ["c1"])
    }
    
    func test_ThrowError_IfTwoPlayersLeft() throws {
        // Given
        let c1 = inventory.getCard("beer", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 1, hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupInitialState(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsFailure(events[0], equalTo: .playersMustBeAtLeast(3))
    }
    
    func test_ThrowError_IfMaxHealth() throws {
        // Given
        let c1 = inventory.getCard("beer", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 4, hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1")
        setupInitialState(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsFailure(events[0], equalTo: .playerAlreadyMaxHealth("p1"))
    }
    
}
