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

final class BeerTests: EngineTestCase {
    
    func test_GainHealth_IfPlayingBeer() throws {
        // Given
        let c1 = inventory.getCard("beer", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 1, hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .success(Heal(player: PlayerId("p1"), value: 1))
        ])
    }
    
    func test_ThrowError_IfTwoPlayersLeft() throws {
        // Given
        let c1 = inventory.getCard("beer", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 1, hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([.error(.playersMustBeAtLeast(3))])
    }
    
    func test_ThrowError_IfMaxHealth() throws {
        // Given
        let c1 = inventory.getCard("beer", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 4, hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([.error(.playerAlreadyMaxHealth("p1"))])
    }
    
}
